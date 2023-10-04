# Oh My Tmux Manager

[![GitHub license](https://img.shields.io/github/license/Hzbeta/omt-manager)](LICENSE)
[![GitHub Actions Test](https://github.com/Hzbeta/omt-manager/actions/workflows/test.yaml/badge.svg)](https://github.com/Hzbeta/omt-manager/actions)
[![Test Coverage](https://img.shields.io/badge/test%20coverage-100%25-brightgreen)](https://github.com/Hzbeta/omt-manager/actions)

*Oh My Tmux* Manager (OMT Manager) is a shell plugin that helps you to easily manage your Tmux configurations. With OMT Manager, you can install, remove, and upgrade [*Oh My Tmux*](https://github.com/gpakosz/.tmux) with just a few commands.

- [Oh My Tmux Manager](#oh-my-tmux-manager)
  - [Features](#features)
  - [Installation](#installation)
    - [With Plugin Manager](#with-plugin-manager)
      - [For Zsh](#for-zsh)
    - [Manual Installation](#manual-installation)
  - [Usage](#usage)
    - [Basic Usage](#basic-usage)
    - [Options](#options)
      - [Install](#install)
      - [Remove](#remove)
      - [Upgrade](#upgrade)
  - [Custom Configuration](#custom-configuration)
  - [Development](#development)
  - [License](#license)

## Features

- Install and setup *Oh My Tmux* easily
- Customize the installation path of *Oh My Tmux* and the configuration path of Tmux
- Remove *Oh My Tmux* and related configurations
- Upgrade *Oh My Tmux* to the latest version
- Backup and restore user configurations

## Installation

You can install the OMT Manager using a plugin manager or manually.

### With Plugin Manager

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

## Usage

Use the `omt` command to manage your *Oh My Tmux* installation:

```sh
omt [install|remove|upgrade]
```

### Basic Usage

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

## Custom Configuration

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

## Development

To develop this plugin, you need to install the following dependencies:
- [act](https://github.com/nektos/act): A tool for running GitHub Actions locally.
- [shUnit2](https://github.com/kward/shunit2): A unit test framework for Bash.
- [bashcov](https://github.com/infertux/bashcov): A code coverage analysis tool for Bash.

And then, you can run the following commands to start developing:
1. Clone the repository.
2. Open the repository in your favorite editor.
3. Make changes to the code.
4. Run `bash ./tests/coverage_report.sh` to test your changes and generate a coverage report, please make sure that the coverage is 100%.
5. Run `act` to test your changes with GitHub Actions locally.
6. Push your changes to GitHub and create a Pull Request.

Tips:
- If you are using VS Code, you can use the Dev Container to develop this plugin without installing any dependencies. See [here](https://code.visualstudio.com/docs/remote/containers) for more details.
- And if you are using WSL2 and Docker Desktop, please run `docker login` in WSL2, before opening Dev Container to avoid the `credsStore` error.
- The default Dockerfile does not contain the `act` tool, as `act` utilizes Docker itself. If you want to use `act` within the Dev Container, you will need to configure Docker in Docker (DinD) or Docker out of Docker (DooD) manually.

## License

This project is released under the Apache License 2.0. See [LICENSE](LICENSE) for more details.