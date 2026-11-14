// NAME: Spotify Backup
// AUTHOR: OhItsTom
// DESCRIPTION: Backup / restore application data (settings) + to the cloud (Gist).
// TODO: also backup/parse prefs + productstate + simplify overall code

(async function spotifyBackup() {
	if (!(Spicetify.Platform && Spicetify.React && Spicetify.ReactDOM && Spicetify.Platform.History && Spicetify.Locale._dictionary)) {
		setTimeout(spotifyBackup, 10);
		return;
	}

	// Settings Config
	let config = JSON.parse(localStorage.getItem("spotifyBackup:settings") || "{}");
	let gist = {
		data: null,
		lastUpdate: null
	};

	function getConfig(key) {
		return config[key] ?? null;
	}

	function setConfig(key, value, message) {
		if (value === getConfig(key)) return;
		console.debug(`[spotifyBackup-Config]: ${message ?? key + " ="}`, value);
		config[key] = value;
		localStorage.setItem("spotifyBackup:settings", JSON.stringify(config));
	}

	// Time related functions
	function timeSince(timestamp) {
		return new Date() - new Date(timestamp);
	}

	function setLastBackupTime(time) {
		setConfig("lastBackupTimestamp", time ?? new Date().toISOString(), "Last backup timestamp");
	}

	// Get the Gist data
	async function getGist(force = false) {
		// Return null if Gist Integration is disabled
		if (!getConfig("gistEnabled")) return { data: null, lastUpdate: null };
		// Return cached data if the last update was less than a minute ago
		if (timeSince(gist.lastUpdate) < 60 * 1000 && !force) return gist;

		const response = await fetch(`https://api.github.com/gists/${getConfig("gistId")}`, {
			headers: {
				Authorization: `token ${getConfig("gistToken")}`
			}
		});

		let parsedData = null,
			lastUpdate = null;
		if (response.ok) {
			const data = await response.json();
			lastUpdate = data.updated_at;
			parsedData = JSON.parse(data.files["spotify-backup.json"].content);
		} else {
			Spicetify.showNotification("Failed to retrieve Gist content", true);
			console.error("Gist API responded with status:", response.status);
		}
		if (parsedData) gist = { data: parsedData, lastUpdate };
		return gist;
	}

	async function waitForMarketplace() {
		// Both legacy and IndexedDB-backed Marketplace expose export(); the latter
		// only exposes it after storage hydration. Do not back up a partial startup state.
		const installed =
			Spicetify.Config?.custom_apps?.includes("marketplace") ||
			Spicetify.Config?.extensions?.some(name => /(^|\/)marketplace\.js$/.test(name));
		if (!installed) return;
		if (typeof window.Marketplace?.export !== "function") Spicetify.showNotification("Waiting for Marketplace to initialize");
		while (typeof window.Marketplace?.export !== "function") {
			await new Promise(resolve => setTimeout(resolve, 250));
		}
	}

	function openMarketplaceDatabase() {
		if (!window.indexedDB) return Promise.resolve(null);
		return new Promise((resolve, reject) => {
			// No version argument: never upgrade a database owned by Marketplace.
			const request = window.indexedDB.open("spicetify-marketplace");
			let missing = false;
			let finished = false;
			const finish = (database, error) => {
				if (finished) {
					database?.close();
					return;
				}
				finished = true;
				if (error) reject(error);
				else resolve(database);
			};
			request.onupgradeneeded = () => {
				// Opening a missing database would create it. Leave legacy installs alone.
				missing = true;
				request.transaction.abort();
			};
			request.onerror = () => finish(null, missing ? null : request.error);
			request.onblocked = () => finish(null, new Error("Marketplace database is blocked"));
			request.onsuccess = () => {
				const database = request.result;
				if (!database.objectStoreNames.contains("settings")) {
					database.close();
					finish(null, new Error("Marketplace settings store is missing"));
					return;
				}
				database.onversionchange = () => database.close();
				finish(database);
			};
		});
	}

	async function restoreMarketplaceData(data, restoreLocalStorage) {
		// Older Spotify Backup exports may have omitted Marketplace entirely.
		// Do not erase an existing database when there is no Marketplace data to restore.
		if (!Object.keys(data).some(key => key.startsWith("marketplace:"))) return restoreLocalStorage();
		// IndexedDB was introduced in Marketplace 1.0.9. A downgraded legacy
		// Marketplace may legitimately disagree with the database it left behind.
		const version = window.Marketplace?.version?.split(".").map(Number);
		let usesIndexedDB = version && (version[0] > 1 || (version[0] === 1 && (version[1] > 0 || version[2] >= 9)));
		const snapshot = usesIndexedDB ? window.Marketplace.export() : null;
		const database = await openMarketplaceDatabase();
		if (!database) return restoreLocalStorage(); // Legacy Marketplace will migrate localStorage itself.
		try {
			await new Promise((resolve, reject) => {
				const transaction = database.transaction("settings", "readwrite");
				const store = transaction.objectStore("settings");
				const persisted = {};
				transaction.oncomplete = resolve;
				transaction.onabort = () => reject(transaction.error || new Error("Marketplace restore aborted"));
				store.openCursor().onsuccess = event => {
					const cursor = event.target.result;
					if (cursor) {
						if (typeof cursor.key === "string" && cursor.key.startsWith("marketplace:")) {
							persisted[cursor.key] = cursor.value.value;
							cursor.delete();
						}
						cursor.continue();
					} else {
						if (snapshot) {
							const current = window.Marketplace.export();
							const matches = other =>
								Object.keys(snapshot).length === Object.keys(other).length &&
								Object.entries(snapshot).every(([key, value]) => other[key] === value);
							// Migration can leave modern Marketplace using localStorage for
							// this session. Verify the actual source rather than assuming the
							// version implies a successfully migrated database.
							const local = {};
							for (const key of Object.keys(localStorage)) {
								if (key.startsWith("marketplace:")) local[key] = localStorage.getItem(key);
							}
							if (!matches(persisted) && Object.keys(snapshot).length > 0 && matches(local)) usesIndexedDB = false;
							if (!matches(current) || (usesIndexedDB && !matches(persisted))) {
								transaction.abort();
								reject(new Error("Marketplace settings changed or are still being saved; retry restore when Marketplace is idle"));
								return;
							}
						}
						// Replace Marketplace records, but preserve migration markers and other metadata.
						for (const [key, value] of Object.entries(data)) {
							if (key.startsWith("marketplace:")) store.put({ key, value });
						}
						// Keep the transaction abortable until the synchronous localStorage
						// writes succeed, including their quota checks.
						try {
							restoreLocalStorage(usesIndexedDB);
						} catch (error) {
							transaction.abort();
							reject(error);
						}
					}
				};
			});
		} finally {
			database.close();
		}
	}

	async function sanitizeBackupData() {
		await waitForMarketplace();
		const data = {};
		for (let key in localStorage) {
			if (Object.prototype.hasOwnProperty.call(localStorage, key)) {
				data[key] = localStorage[key];
			}
		}
		if (typeof window.Marketplace?.export === "function") {
			// Let the running Marketplace choose its backend, including after a downgrade.
			// Replace the whole namespace so stale/deleted localStorage keys do not return.
			const marketplaceData = window.Marketplace.export();
			if (!marketplaceData || typeof marketplaceData !== "object" || Array.isArray(marketplaceData)) {
				throw new Error("Invalid Marketplace export");
			}
			for (const key of Object.keys(data)) {
				if (key.startsWith("marketplace:")) delete data[key];
			}
			for (const [key, value] of Object.entries(marketplaceData)) {
				if (!key.startsWith("marketplace:")) continue;
				if (typeof value !== "string") throw new Error("Invalid Marketplace setting");
				data[key] = value;
			}
			// An explicit empty inventory distinguishes new empty snapshots from
			// historical backups that omitted Marketplace entirely.
			if (Object.keys(marketplaceData).length === 0) data["marketplace:installed-extensions"] = "[]";
		}
		// Parse spotifyBackup:settings and exclude sensitive data
		if (data["spotifyBackup:settings"]) {
			try {
				const settings = JSON.parse(data["spotifyBackup:settings"]);
				// Remove GitHub token to prevent GitHub from auto-revoking it
				delete settings.gistToken;
				data["spotifyBackup:settings"] = JSON.stringify(settings);
			} catch (error) {
				console.error("Error sanitizing backup data:", error);
			}
		}
		return data;
	}

	async function backupData() {
		let sanitizedData;
		try {
			sanitizedData = await sanitizeBackupData();
		} catch (error) {
			Spicetify.showNotification("Failed to read backup data", true);
			console.error("Error while collecting backup data:", error);
			return;
		}
		const dataStr = JSON.stringify(sanitizedData);
		if (getConfig("gistEnabled")) {
			// Check if the data is the same as the last backup
			gist = await getGist();
			if (dataStr === JSON.stringify(gist.data)) {
				Spicetify.showNotification("There is nothing to backup");
				return;
			}
			try {
				const formattedData = JSON.stringify(sanitizedData, null, 2);
				// Keep compact output if indentation would exceed the Gist API's inline-content limit.
				const gistContent = new Blob([formattedData]).size <= 1000000 ? formattedData : dataStr;
				const response = await fetch(`https://api.github.com/gists/${getConfig("gistId")}`, {
					method: "PATCH",
					headers: {
						Authorization: `token ${getConfig("gistToken")}`,
						"Content-Type": "application/json"
					},
					body: JSON.stringify({
						files: {
							"spotify-backup.json": {
								content: gistContent
							}
						}
					})
				});
				if (response.ok) {
					Spicetify.showNotification("Backup to Gist successful");
					setLastBackupTime();
				} else {
					Spicetify.showNotification("Failed to backup to Gist", true);
					console.error("Gist API responded with status:", response.status);
				}
			} catch (error) {
				Spicetify.showNotification("Failed to backup to Gist", true);
				console.error("Error while backing up to Gist:", error);
			}
		} else {
			await Spicetify.Platform.ClipboardAPI.copy(dataStr)
				.then(() => {
					Spicetify.showNotification("Copied backup data to clipboard");
					setLastBackupTime();
				})
				.catch(error => {
					Spicetify.showNotification("Failed to backup data", true);
					console.error("Error while copying data:", error);
				});
		}
	}

	async function restoreData() {
		try {
			gist = await getGist();
			const data = getConfig("gistEnabled") ? gist.data : JSON.parse(await Spicetify.Platform.ClipboardAPI.paste());
			if (!data) {
				Spicetify.showNotification("No backup data found", true);
				return;
			}
			if (typeof data !== "object" || Array.isArray(data) || Object.values(data).some(value => typeof value !== "string")) {
				throw new Error("Invalid backup data: expected a flat object of strings");
			}
			const restoredConfig = JSON.parse(data["spotifyBackup:settings"] || "{}");
			if (!restoredConfig || typeof restoredConfig !== "object" || Array.isArray(restoredConfig)) {
				throw new Error("Invalid Spotify Backup settings");
			}
			if (Object.keys(data).some(key => key.startsWith("marketplace:"))) await waitForMarketplace();
			// Backup integration settings belong to this device, not the source device.
			const settings = { ...config, lastBackupTimestamp: gist.lastUpdate ?? new Date().toISOString() };
			const previous = { ...localStorage };
			let localStorageChanged = false;
			try {
				await restoreMarketplaceData(data, usesIndexedDB => {
					localStorageChanged = true;
					localStorage.clear();
					for (const [key, value] of Object.entries(data)) {
						// Modern Marketplace reads its database; duplicating its records can
						// exceed localStorage's smaller quota unnecessarily.
						if (usesIndexedDB && key.startsWith("marketplace:")) continue;
						if (key !== "spotifyBackup:settings") localStorage.setItem(key, value);
					}
					localStorage.setItem("spotifyBackup:settings", JSON.stringify(settings));
				});
			} catch (error) {
				if (localStorageChanged) {
					localStorage.clear();
					for (const [key, value] of Object.entries(previous)) localStorage.setItem(key, value);
				}
				throw error;
			}
			config = settings;
			Spicetify.showNotification("Data restored successfully");
			window.location.reload();
		} catch (error) {
			Spicetify.showNotification("Failed to restore data.", true);
			console.error("Error while restoring data:", error);
		}
	}

	async function checkForNewBackup() {
		if (!getConfig("gistEnabled")) return false;
		gist = await getGist();
		const lastUpdate = new Date(gist.lastUpdate);
		const lastBackup = new Date(getConfig("lastBackupTimestamp"));
		return lastUpdate > lastBackup;
	}

	async function startupCheck() {
		const backupInterval = getConfig("backupInterval");
		if (backupInterval === "off" || !getConfig("gistEnabled")) return;

		const lastBackupTimestamp = getConfig("lastBackupTimestamp");

		if (
			backupInterval === "startup" ||
			(backupInterval === "daily" && (!lastBackupTimestamp || timeSince(lastBackupTimestamp) > 24 * 60 * 60 * 1000))
		) {
			if (await checkForNewBackup()) {
				// If the local data is older than the Gist data, restore it
				await restoreData();
			} else {
				// If the local data is newer than the Gist data, back it up
				await backupData();
			}
		}
	}

	const classes = {
		section: "x-settings-section",
		header: "encore-text encore-text-body-medium-bold encore-internal-color-text-base",
		row: "x-settings-row",
		first: "x-settings-firstColumn",
		second: "x-settings-secondColumn",
		button:
			"Button-buttonSecondary-small-useBrowserDefaultFocusStyle Button-small-buttonSecondary-useBrowserDefaultFocusStyle Button-small-buttonSecondary-isUsingKeyboard-useBrowserDefaultFocusStyle Button-buttonSecondary-small-isUsingKeyboard-useBrowserDefaultFocusStyle encore-text-body-small-bold x-settings-button",
		toggleWrapper: "x-toggle-wrapper",
		toggleInput: "x-toggle-input",
		toggleIndicatorWrapper: "x-toggle-indicatorWrapper",
		toggleIndicator: "x-toggle-indicator",
		select: "main-dropDown-dropDown",
		input: "x-settings-input"
	};

	// Spotify's settings page classes are hashed per build (the x-settings-* names no
	// longer exist), so copy them from native elements at insert time. The defaults
	// above are the legacy names, used if discovery finds nothing.
	function discoverClasses(storageSection) {
		const pick = (key, value) => {
			if (value && typeof value === "string") classes[key] = value;
		};
		const page = storageSection.parentElement ?? document;
		const row = storageSection.querySelector("[data-settings-row]");
		pick("section", storageSection.className);
		pick("header", storageSection.firstElementChild?.className);
		if (row) {
			pick("row", row.className);
			pick("first", row.children[0]?.className);
			pick("second", row.children[1]?.className);
			pick("button", row.querySelector("button")?.className);
		}
		const toggle = page.querySelector('input[type="checkbox"]:not([data-spotify-backup])');
		if (toggle) {
			pick("toggleInput", toggle.className);
			pick("toggleWrapper", toggle.parentElement?.className);
			pick("toggleIndicatorWrapper", toggle.nextElementSibling?.className);
			pick("toggleIndicator", toggle.nextElementSibling?.firstElementChild?.className);
		}
		pick("select", page.querySelector("select:not([data-spotify-backup])")?.className);
		pick("input", page.querySelector('input[type="text"]:not([data-spotify-backup]), input[type="search"]:not([data-spotify-backup])')?.className);
	}

	// Basic dialog component
	const Dialog = Spicetify.React.memo(props => {
		const [state, setState] = Spicetify.React.useState(true);
		const self = document.querySelector(".ReactModalPortal:last-of-type");
		const ConfirmDialog = Spicetify.ReactComponent.ConfirmDialog;
		const isForwardRef = typeof ConfirmDialog === "function";
		const commonProps = {
			...props,
			isOpen: state,
			onClose: () => {
				setState(false);
				props.onClose?.();
				self?.remove();
			},
			onConfirm: () => {
				setState(false);
				props.onConfirm?.();
				self?.remove();
			}
		};

		Spicetify.React.useEffect(() => {
			if (state) props.onOpen?.();
		}, [state]);

		return isForwardRef ? ConfirmDialog(commonProps) : Spicetify.React.createElement(ConfirmDialog, commonProps);
	});

	function showDialog(props) {
		Spicetify.ReactDOM.render(
			Spicetify.React.createElement(
				Spicetify.ReactComponent.RemoteConfigProvider,
				{ configuration: Spicetify.Platform.RemoteConfiguration },
				Spicetify.React.createElement(Dialog, props)
			),
			document.createElement("div")
		);
	}

	// Create our own section matching Spotify's
	const Section = Spicetify.React.memo(() => {
		const [localStorageSize, setLocalStorageSize] = Spicetify.React.useState("");
		const [gistEnabled, setGistEnabled] = Spicetify.React.useState(getConfig("gistEnabled") ?? false);
		const [gistToken, setGistToken] = Spicetify.React.useState(getConfig("gistToken") ?? "");
		const [gistId, setGistId] = Spicetify.React.useState(getConfig("gistId") ?? "");
		const [backupInterval, setBackupInterval] = Spicetify.React.useState(getConfig("backupInterval") ?? "off");

		Spicetify.React.useEffect(() => {
			if (getConfig("gistEnabled") !== gistEnabled) setConfig("gistEnabled", gistEnabled);
			if (getConfig("gistToken") !== gistToken) setConfig("gistToken", gistToken);
			if (getConfig("gistId") !== gistId) setConfig("gistId", gistId);
			if (getConfig("backupInterval") !== backupInterval) setConfig("backupInterval", backupInterval);
		}, [gistEnabled, gistToken, gistId, backupInterval]);

		Spicetify.React.useEffect(() => {
			getLocalStorageSize().then(size => setLocalStorageSize(size));
		}, []);

		function getLocalStorageSize() {
			return new Promise(resolve => {
				requestIdleCallback(() => {
					let localStorageString = JSON.stringify(localStorage);
					let totalSizeBytes = new Blob([localStorageString]).size;

					const units = ["bytes", "KB", "MB", "GB"];
					let size = totalSizeBytes;
					let unitIndex = 0;

					while (size >= 1024 && unitIndex < units.length - 1) {
						size /= 1024;
						unitIndex++;
					}

					resolve(`${Math.trunc(size)} ${units[unitIndex]}`);
				});
			});
		}

		return [
			Spicetify.React.createElement(
				"h2",
				{
					"data-encore-id": "type",
					className: classes.header
				},
				"Backup"
			),
			Spicetify.React.createElement(
				"div",
				{
					className: classes.row,
					"data-settings-row": ""
				},
				[
					Spicetify.React.createElement("div", { className: classes.first }, [
						Spicetify.React.createElement("div", null, [
							Spicetify.React.createElement("div", null, [
								Spicetify.React.createElement(
									"label",
									{
										className: "encore-text encore-text-body-small encore-internal-color-text-base",
										"data-encore-id": "text"
									},
									`Application Data:`
								),
								Spicetify.React.createElement(
									"label",
									{
										className: "encore-text encore-text-body-small encore-internal-color-text-subdued",
										"data-encore-id": "text"
									},
									` ${localStorageSize}`
								)
							]),
							Spicetify.React.createElement(
								"label",
								{
									className: "encore-text encore-text-body-small encore-internal-color-text-subdued",
									"data-encore-id": "text"
								},
								`Content stored in the browser (local storage)`
							)
						])
					]),
					Spicetify.React.createElement("div", { className: classes.second }, [
						Spicetify.React.createElement(
							"button",
							{
								className: classes.button,
								"data-encore-id": "buttonSecondary",
								style: {
									marginRight: "8px"
								},
								onClick: async () => await backupData()
							},
							"Backup"
						),
						Spicetify.React.createElement(
							"button",
							{
								className: classes.button,
								"data-encore-id": "buttonSecondary",
								style: {
									marginRight: "8px"
								},
								onClick: async () => {
									showDialog({
										titleText: "Are you sure?",
										descriptionText: "This will overwrite all your current settings!",
										cancelText: "Cancel",
										confirmText: "Restore",
										onConfirm: async () => await restoreData()
									});
								}
							},
							"Restore"
						),
						Spicetify.React.createElement(
							"button",
							{
								className: classes.button,
								"data-encore-id": "buttonSecondary",
								disabled: !gistEnabled,
								onClick: async () => {
									if (await checkForNewBackup()) {
										showDialog({
											titleText: "New backup found!",
											descriptionText: "Would you like to restore the backup?\nThis will overwrite all your current settings!",
											cancelText: "Cancel",
											confirmText: "Restore",
											onConfirm: async () => await restoreData()
										});
									} else {
										showDialog({
											titleText: "No new backup found!",
											descriptionText: "Would you like to backup your current settings?",
											cancelText: "Cancel",
											confirmText: "Backup",
											onConfirm: async () => await backupData()
										});
									}
								}
							},
							"Check"
						)
					])
				]
			),
			Spicetify.React.createElement(
				"div",
				{
					className: classes.row
				},
				[
					Spicetify.React.createElement(
						"div",
						{ className: classes.first },
						Spicetify.React.createElement("div", null, [
							Spicetify.React.createElement(
								"div",
								null,
								Spicetify.React.createElement(
									"label",
									{ className: "encore-text encore-text-body-small encore-internal-color-text-base", "data-encore-id": "text" },
									"Gist Integration"
								)
							),

							Spicetify.React.createElement(
								"label",
								{
									className: "encore-text encore-text-body-small encore-internal-color-text-subdued",
									"data-encore-id": "text"
								},
								"Remote storage for your data (see README for more info)"
							)
						])
					),
					Spicetify.React.createElement(
						"div",
						{ className: classes.second },
						Spicetify.React.createElement(
							"label",
							{ className: classes.toggleWrapper },
							Spicetify.React.createElement("input", {
								id: "settings.canvasVideos",
								"data-spotify-backup": "",
								className: classes.toggleInput,
								type: "checkbox",
								checked: gistEnabled,
								onChange: () => setGistEnabled(!gistEnabled)
							}),
							Spicetify.React.createElement(
								"span",
								{ className: classes.toggleIndicatorWrapper },
								Spicetify.React.createElement("span", { className: classes.toggleIndicator })
							)
						)
					)
				]
			),
			gistEnabled && [
				Spicetify.React.createElement(
					"div",
					{
						className: classes.row
					},
					[
						Spicetify.React.createElement(
							"div",
							{ className: classes.first },

							Spicetify.React.createElement(
								"label",
								{ className: "encore-text encore-text-body-small encore-internal-color-text-subdued", "data-encore-id": "text" },
								"Check Interval"
							)
						),
						Spicetify.React.createElement(
							"div",
							{ className: classes.second },
							Spicetify.React.createElement(
								"span",
								null,
								Spicetify.React.createElement(
									"select",
									{
										className: classes.select,
										id: "desktop.settings.autostart",
										"data-spotify-backup": "",
										onChange: e => setBackupInterval(e.target.value),
										value: backupInterval
									},
									[
										Spicetify.React.createElement("option", { value: "off" }, "Off"),
										Spicetify.React.createElement("option", { value: "startup" }, "Startup"),
										Spicetify.React.createElement("option", { value: "daily" }, "Daily")
									]
								)
							)
						)
					]
				),
				Spicetify.React.createElement("div", { style: { marginTop: "10px" } }, [
					Spicetify.React.createElement("input", {
						type: "text",
						placeholder: "GitHub Token",
							"data-spotify-backup": "",
						value: gistToken,
						onChange: e => setGistToken(e.target.value),
						className: classes.input,
						type: "password"
					}),
					Spicetify.React.createElement("input", {
						type: "text",
						placeholder: "Gist ID",
							"data-spotify-backup": "",
						value: gistId,
						onChange: e => setGistId(e.target.value),
						className: classes.input,
						style: { marginTop: "5px" }
					})
				])
			]
		];
	});

	// Function to insert our section into the settings page
	function insertOption(name) {
		if (name !== "/preferences") return;

		const storageTitle = Spicetify.Locale._dictionary["desktop.settings.storage"];
		const started = Date.now();
		const checkHeaderInterval = setInterval(() => {
			// Give up if the settings page never shows the Storage section
			if (Date.now() - started > 15000) return clearInterval(checkHeaderInterval);
			// Class names are hashed now: find the Storage section via its heading text
			for (const heading of document.querySelectorAll("h1, h2, h3")) {
				if (heading.textContent !== storageTitle) continue;
				const section = heading.parentElement;
				if (!section || section.nextElementSibling?.hasAttribute("data-spotify-backup-section")) {
					clearInterval(checkHeaderInterval);
					return;
				}

				clearInterval(checkHeaderInterval);
				discoverClasses(section);
				const sectionContainer = document.createElement("div");
				sectionContainer.className = classes.section;
				sectionContainer.setAttribute("data-spotify-backup-section", "");
				Spicetify.ReactDOM.render(Spicetify.React.createElement(Section), sectionContainer);
				section.parentNode.insertBefore(sectionContainer, section.nextSibling);
				return;
			}
		}, 50);
	}

	// Hotload useEffect
	Spicetify.ReactDOM.render(Spicetify.React.createElement(Section), document.createElement("div"));

	// Init
	startupCheck();
	Spicetify.Platform.History.listen(event => {
		insertOption(event.pathname);
	});
	insertOption(Spicetify.Platform.History.location.pathname);
})();
