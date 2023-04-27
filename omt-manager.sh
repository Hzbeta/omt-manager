# Set default values for environment variables
: "${MANAGER_OMT_DIR_PATH:="${HOME}/.tmux"}"
: "${MANAGER_OMT_CONF_PATH:="${HOME}/.tmux.conf"}"
: "${MANAGER_OMT_LOCAL_CONF_PATH:="${HOME}/.tmux.conf.local"}"
: "${MANAGER_OMT_REPO_URL:="https://github.com/gpakosz/.tmux.git"}"
export MANAGER_OMT_DIR_PATH
export MANAGER_OMT_CONF_PATH
export MANAGER_OMT_LOCAL_CONF_PATH
export MANAGER_OMT_REPO_URL

_omt_help() {
    echo "Usage: omt [install|remove|upgrade]"
    echo "Use omt -h for more information"
}

omt() {
    case "$1" in
    install)
        _omt_install "${@:2}"
        return_code=$?
        OPTIND=1
        ;;
    remove)
        _omt_remove "${@:2}"
        return_code=$?
        OPTIND=1
        ;;
    upgrade)
        _omt_upgrade "${@:2}"
        return_code=$?
        OPTIND=1
        ;;
    -h)
        _omt_help
        return_code=0
        ;;
    *)
        _omt_help
        return_code=1
        ;;
    esac
    return $return_code
}

_omt_install_help() {
    echo "Usage: omt install [-s] [-f] [-o] [-h]"
    echo "Options:"
    echo "  -s    Silent mode, suppress output"
    echo "  -f    Force install, remove existing Oh My Tmux and reinstall, backup and replace existing .tmux.conf"
    echo "  -o    Overwrite user config, backup and replace existing .tmux.conf.local (must be used with -f)"
    echo "  -h    Show help information"
}

_mkdir() {
    if [[ -d "$1" ]]; then
        return 0
    fi
    mkdir -p "$1" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        [ "$2" = false ] && echo "Failed to create directory $1."
        return 1
    fi
}

_omt_install() {
    local silent=false force=false overwrite_usr_conf=false

    while getopts "sfho" opt; do
        case "$opt" in
        s) silent=true ;;
        f) force=true ;;
        o) overwrite_usr_conf=true ;;
        h)
            _omt_install_help
            return 0
            ;;
        *)
            _omt_install_help
            return 1
            ;;
        esac
    done

    # create directories
    _mkdir "$(dirname "$MANAGER_OMT_DIR_PATH")" $silent || return 1
    _mkdir "$(dirname "$MANAGER_OMT_CONF_PATH")" $silent || return 1
    _mkdir "$(dirname "$MANAGER_OMT_LOCAL_CONF_PATH")" $silent || return 1

    # check if -o is used with -f
    if [[ "$overwrite_usr_conf" = true && "$force" = false ]]; then
        [[ "$silent" = false ]] && echo "The -o option must be used with -f."
        return 1
    fi

    # check if Oh My Tmux or .tmux.conf exists
    if [[ -d "$MANAGER_OMT_DIR_PATH" || -f "$MANAGER_OMT_CONF_PATH" ]]; then
        if [[ "$force" = true ]]; then
            [[ -d "$MANAGER_OMT_DIR_PATH" ]] && rm -rf "$MANAGER_OMT_DIR_PATH"
        else
            [[ "$silent" = false ]] && echo "Oh My Tmux already exists or .tmux.conf is present. Use -f option to force install."
            return 1
        fi
    fi

    if [[ "$silent" = true ]]; then
        git clone $MANAGER_OMT_REPO_URL "$MANAGER_OMT_DIR_PATH" >/dev/null 2>&1
    else
        git clone $MANAGER_OMT_REPO_URL "$MANAGER_OMT_DIR_PATH"
    fi

    if [[ $? -ne 0 ]]; then
        [[ "$silent" = false ]] && echo "Failed to clone Oh My Tmux repository."
        return 1
    fi

    # if .tmux.conf exists, force must be true here
    [[ -f "$MANAGER_OMT_CONF_PATH" ]] && cp "$MANAGER_OMT_CONF_PATH" "${MANAGER_OMT_CONF_PATH}.bak"

    cp "${MANAGER_OMT_DIR_PATH}/.tmux.conf" "$MANAGER_OMT_CONF_PATH"

    # if .tmux.conf.local exists
    if [[ -f "$MANAGER_OMT_LOCAL_CONF_PATH" ]]; then
        if [[ "$force" = true && "$overwrite_usr_conf" = true ]]; then
            cp "$MANAGER_OMT_LOCAL_CONF_PATH" "${MANAGER_OMT_LOCAL_CONF_PATH}.bak"
            cp "${MANAGER_OMT_DIR_PATH}/.tmux.conf.local" "$MANAGER_OMT_LOCAL_CONF_PATH"
        else
            [[ "$silent" = false ]] && echo ".tmux.conf.local already exists. Use -fo options to to backup and overwrite it."
            return 1
        fi
    else
        cp "${MANAGER_OMT_DIR_PATH}/.tmux.conf.local" "$MANAGER_OMT_LOCAL_CONF_PATH"
    fi
}

_omt_remove_help() {
    echo "Remove Oh My Tmux and .tmux.conf"
    echo "Usage: omt remove [-a] [-h]"
    echo "Options:"
    echo "  -a    Be careful, will remove .tmux.conf.local"
    echo "  -h    Show help information"
}

_omt_remove() {
    local remove_all=false

    while getopts "ah" opt; do
        case "$opt" in
        a) remove_all=true ;;
        h)
            _omt_remove_help
            return 0
            ;;
        *)
            _omt_remove_help
            return 1
            ;;
        esac
    done

    if [[ -d "$MANAGER_OMT_DIR_PATH" ]]; then
        rm -rf "$MANAGER_OMT_DIR_PATH"
    fi
    if [[ -f "$MANAGER_OMT_CONF_PATH" ]]; then
        rm -f "$MANAGER_OMT_CONF_PATH"
    fi
    if [[ -f "$MANAGER_OMT_LOCAL_CONF_PATH" ]] && [[ "$remove_all" = true ]]; then
        rm -f "$MANAGER_OMT_LOCAL_CONF_PATH"
    fi
    return 0
}

_omt_upgrade_help() {
    echo "Do not change the local Oh My Tmux repo, the local changes will be lost when upgrade."
    echo "Usage: omt upgrade [-s] [-o] [-h]"
    echo "Options:"
    echo "  -s    Silent mode, suppress output"
    echo "  -o    Overwrite user config, backup and replace existing .tmux.conf.local"
    echo "  -h    Show help information"
}

_omt_upgrade() {
    local silent=false overwrite_usr_conf=false

    while getopts "sho" opt; do
        case "$opt" in
        s) silent=true ;;
        o) overwrite_usr_conf=true ;;
        h)
            _omt_upgrade_help
            return 0
            ;;
        *)
            _omt_upgrade_help
            return 1
            ;;
        esac
    done

    # check if omt installed
    if [[ ! -d "$MANAGER_OMT_DIR_PATH" ]]; then
        [[ "$silent" = false ]] && echo "Oh My Tmux is not installed."
        return 1
    fi

    local branch_name
    branch_name=$(git -C "$MANAGER_OMT_DIR_PATH" symbolic-ref --short HEAD)
    if [[ -z "$branch_name" ]]; then
        if [[ "$silent" = false ]]; then
            echo "Failed to determine the current branch name for local Oh My Tmux."
            echo "Please check if it is a valid git repository."
            echo "You can use \"omt install -f\" to force re-install."
        fi
        return 1
    fi

    git -C "$MANAGER_OMT_DIR_PATH" fetch
    if [[ $? -ne 0 ]]; then
        [[ "$silent" = false ]] && echo "Failed to fetch updates."
        return 1
    fi

    output=$(git -C "$MANAGER_OMT_DIR_PATH" status)
    if [[ "$output" == *"Your branch is up to date"* ]]; then
        [[ "$silent" = false ]] && echo "Oh My Tmux is already up to date."
        return 0
    fi

    git -C "$MANAGER_OMT_DIR_PATH" reset --hard origin/"$branch_name" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        [[ "$silent" = false ]] && echo "Failed to merge updates."
        return 1
    fi

    cp -f "${MANAGER_OMT_DIR_PATH}/.tmux.conf" "$MANAGER_OMT_CONF_PATH"

    if [[ "$overwrite_usr_conf" = true ]]; then
        [[ -f "$MANAGER_OMT_LOCAL_CONF_PATH" ]] && cp "$MANAGER_OMT_LOCAL_CONF_PATH" "${MANAGER_OMT_LOCAL_CONF_PATH}.bak"
        cp -f "${MANAGER_OMT_DIR_PATH}/.tmux.conf.local" "$MANAGER_OMT_LOCAL_CONF_PATH"
    fi

    echo "Oh My Tmux has been upgraded to the latest version."
    echo "Please use tmux source-file \"$MANAGER_OMT_CONF_PATH\" to reload the config."

    return 0
}
