# Oh My Tmux Manager

[![GitHub license](https://img.shields.io/github/license/Hzbeta/omt-manager)](LICENSE)
[![GitHub Actions Test](https://github.com/Hzbeta/omt-manager/actions/workflows/test.yaml/badge.svg)](https://github.com/Hzbeta/omt-manager/actions)
[![Test Coverage](https://img.shields.io/badge/test%20coverage-100%25-brightgreen)](https://github.com/Hzbeta/omt-manager/actions)

*Oh My Tmux* Manager (OMT Manager) is a shell plugin that helps you to easily manage your Tmux configurations. With OMT Manager, you can install, remove, and upgrade [*Oh My Tmux*](https://github.com/gpakosz/.tmux) with just a few commands.

## Features

- Install and setup *Oh My Tmux* easily
- Customize the installation path of *Oh My Tmux* and the configuration path of Tmux
- Remove *Oh My Tmux* and related configurations
- Upgrade *Oh My Tmux* to the latest version
- Backup and restore user configurations

## Installation

You can install the OMT Manager using a plugin manager or manually.

### Plugin Manager

#### For Zsh

- **Zinit / Zi**

  Add the following content to your `.zshrc`:

  ```sh
  zinit load Hzbeta/omt-manager
  ```

  Further, you can use the following config to:

  - Lazy load the plugin when you installed Tmux.
  - Install *Oh My Tmux* automatically when the plugin is loaded.
  - If *Oh My Tmux* is already installed, the plugin won't do anything.

  ```sh
  zinit ice wait lucid has'tmux' atload'omt install -s'
  zinit load Hzbeta/omt-manager
  ```

- **Oh My Zsh**

  1. Clone the repository into the `$ZSH_CUSTOM/plugins` directory:

  ```sh
  git clone https://github.com/Hzbeta/omt-manager.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/omt-manager"
  ```

  2. Add the plugin to the `plugins` array in your `.zshrc`:

  ```sh
  plugins=(... omt-manager)
  ```

- **Antigen**

  Add the following line to your `.zshrc`:

  ```sh
  antigen bundle Hzbeta/omt-manager
  ```

- **Zplug**

  Add the following line to your `.zshrc`:

  ```sh
  zplug "Hzbeta/omt-manager"
  ```

<!-- Supplement other bash plugin managers if needed -->

### Manual Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Hzbeta/omt-manager.git
   ```

2. Add the following line to your `.zshrc` (for Zsh) or `.bashrc` (for Bash), replacing `/path/to/omt-manager.sh` with the actual path to the `omt-manager.sh` file in the cloned repository:

   ```sh
   source /path/to/omt-manager/omt-manager.sh
   ```

## Configuration

The default installation and configuration paths for Oh My Tmux and Tmux are as follows:

```sh
# Default installation path of Oh My Tmux
MANAGER_OMT_DIR_PATH="${HOME}/.tmux"

# Default configuration paths for Tmux
MANAGER_OMT_CONF_PATH="${HOME}/.tmux.conf"
MANAGER_OMT_LOCAL_CONF_PATH="${HOME}/.tmux.conf.local"
```

You can Customize the installation path of *Oh My Tmux* and the configuration path of Tmux by setting the following environment variables:

```sh
# Customize the installation path of Oh My Tmux
export MANAGER_OMT_DIR_PATH="$XDG_CONFIG_HOME/tmux/oh-my-tmux"

# Customize the configuration path of Tmux
export MANAGER_OMT_CONF_PATH="$XDG_CONFIG_HOME/tmux/tmux.conf"
export MANAGER_OMT_LOCAL_CONF_PATH="$XDG_CONFIG_HOME/tmux/tmux.conf.local"
```

**Be cautious** when configuring these paths, as this plugin works within the directory of Oh my tmux. If you set the folder path of another Git project as the path for Oh my tmux, that project may become **corrupted**. Therefore, please **double-check your configuration** before running any commands related to this plugin.

## Usage

Use the `omt` command to manage your *Oh My Tmux* installation:

```sh
omt [install|remove|upgrade]
```

### Commands

- `omt install`: Install *Oh My Tmux*
- `omt remove`: Remove *Oh My Tmux* and related configurations
- `omt upgrade`: Upgrade *Oh My Tmux* to the latest version

### Options

#### Install

- `-s`: Silent mode, suppress output
- `-f`: Force install, remove existing *Oh My Tmux* and reinstall, backup and replace existing .tmux.conf
- `-o`: Overwrite user config, backup and replace existing .tmux.conf.local (must be used with -f)
- `-h`: Show help information

#### Remove

- `-a`: Remove .tmux.conf.local as well (be careful!)
- `-h`: Show help information

#### Upgrade

- `-s`: Silent mode, suppress output
- `-o`: Overwrite user config, backup and replace existing .tmux.conf.local
- `-h`: Show help information

## Examples

Install *Oh My Tmux*:

```sh
omt install
```

Force install *Oh My Tmux* and overwrite existing configurations:

```sh
omt install -f -o
```

Remove *Oh My Tmux* and related configurations:

```sh
omt remove
```

Remove *Oh My Tmux*, .tmux.conf, and .tmux.conf.local:

```sh
omt remove -a
```

Upgrade *Oh My Tmux* to the latest version:

```sh
omt upgrade
```

Upgrade *Oh My Tmux* and overwrite existing .tmux.conf.local:

```sh
omt upgrade -o
```

## License

This project is released under the Apache License 2.0. See [LICENSE](LICENSE) for more details.