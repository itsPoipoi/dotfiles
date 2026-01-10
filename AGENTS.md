# AGENTS.md - Dotfiles Development Guidelines

This repository contains configuration files and setup scripts for a Linux desktop environment (Arch Linux with Hyprland). These guidelines help maintain consistency and reliability across all configurations.

## Build/Lint/Test Commands

### Linting Shell Scripts
```bash
# Lint all shell scripts in the repository
find . -name "*.sh" -type f -exec shellcheck {} \;

# Lint a specific script
shellcheck path/to/script.sh

# Check syntax without execution
bash -n path/to/script.sh
```

### Testing Setup Scripts
```bash
# Test setup.sh in dry-run mode (if available)
# Note: Most scripts here are interactive and don't have dry-run modes

# Validate stow configuration
cd ~/dotfiles && stow --simulate -v fastfetch

# Test zsh configuration syntax
zsh -n ~/.zshrc
```

### Configuration Validation
```bash
# Validate JSON configurations
jq . fastfetch/.config/fastfetch/config.jsonc

# Check if configurations can be loaded
hyprctl reload  # Test Hyprland config
```

## Code Style Guidelines

### Shell Scripts (.sh files)

#### File Structure
```bash
#!/usr/bin/env sh
# Brief description of what the script does

# Color constants (if needed)
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'
YELLOW=$'\e[0;33m'
NC=$'\e[0m'  # No Color

# Function definitions
function_name() {
    # Function body
}

# Main script logic
# ...

# Exit with appropriate code
exit 0
```

#### Naming Conventions
- **Variables**: Use `UPPER_CASE` for global constants, `lower_case` for local variables
- **Functions**: Use `lower_case` with underscores for readability
- **Files**: Use `CamelCase.sh` for executable scripts, `lower-case` for config files

#### Best Practices
- Always use `#!/usr/bin/env sh` or `#!/usr/bin/env zsh` shebang
- Quote variables: `"$VARIABLE"` instead of `$VARIABLE`
- Use `set -e` for strict error handling when appropriate
- Add error handling for critical operations: `command || exit 1`
- Redirect stderr for non-critical operations: `command 2>/dev/null`
- Use `|| true` for commands that may fail but shouldn't stop execution
- Add comments for complex logic or non-obvious operations

#### Example Patterns
```bash
# Good: Quoted variables and error handling
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE" || {
        echo "${RED}Failed to source $CONFIG_FILE${NC}" >&2
        exit 1
    }
fi

# Good: Silent operation with fallback
command 2>/dev/null || true

# Good: User interaction with clear prompts
echo "${YELLOW}Continue with operation?${NC}"
echo "${RED}Press ${GREEN}Y${RED} to accept / Any other key to refuse:${NC}"
read -n 1 -r user_input
```

### Configuration Files

#### Hyprland Configuration
- Use `bindd` for documented keybindings with descriptions
- Group related settings together
- Use descriptive comments for complex configurations
- Follow existing patterns for unbinding defaults

#### Zsh Configuration
- Group plugin loading logically
- Use zinit for plugin management
- Configure completion styling consistently
- Keep history and keybinding settings organized

#### JSON/JSONC Files
- Use 2-space indentation
- Add comments for complex configurations
- Validate with `jq` before committing

### General Guidelines

#### File Organization
- Keep related configurations in dedicated directories (e.g., `hypr/`, `zshrc/`, `kitty/`)
- Use stow-compatible directory structures
- Maintain consistent naming across similar files

#### Error Handling
- Scripts should handle common failure cases gracefully
- Provide meaningful error messages to users
- Use exit codes appropriately (0 for success, 1+ for errors)

#### Security Considerations
- Avoid hardcoding sensitive information
- Use appropriate file permissions (755 for scripts, 644 for configs)
- Validate input when accepting user parameters

#### Documentation
- Add comments for non-obvious configuration choices
- Update README.md when adding new features
- Document any dependencies or prerequisites

### Git Workflow
```bash
# Test changes before committing
git status
git diff --cached

# Commit with descriptive messages
git commit -m "feat: add new keybinding for application launcher

- Added SUPER+SHIFT+A for alternative browser
- Updated bindings.conf with documentation"

# Test configuration after changes
# For Hyprland: hyprctl reload
# For shell: source ~/.zshrc
```

### Testing Checklist
Before committing changes:
- [ ] Run shellcheck on modified scripts
- [ ] Test configuration loading (hyprctl reload, etc.)
- [ ] Verify file permissions are correct
- [ ] Check that stow operations work
- [ ] Test on a clean system if possible

### Dependencies
- Arch Linux with pacman/yay
- Hyprland window manager
- Zsh with zinit
- GNU stow for configuration management
- Various tools: kitty, yazi, fastfetch, lazygit, etc.

### Troubleshooting
- Use `journalctl -xe` for systemd service issues
- Check Hyprland logs with `hyprctl reload` and observe output
- Test scripts with `bash -x script.sh` for debugging
- Validate JSON with `jq` before committing configuration changes</content>
<parameter name="filePath">/home/poipoi/dotfiles/AGENTS.md