assertOMTFileNotExist() {
    assertFalse "Dir $MANAGER_OMT_DIR_PATH found." "[[ -d $MANAGER_OMT_DIR_PATH ]]"
    assertFalse "File $MANAGER_OMT_CONF_PATH found." "[[ -f $MANAGER_OMT_CONF_PATH ]]"
    assertFalse "File $MANAGER_OMT_LOCAL_CONF_PATH found." "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH ]]"
}

assertOMTFileExist() {
    assertTrue "Dir $MANAGER_OMT_DIR_PATH not found." "[[ -d $MANAGER_OMT_DIR_PATH ]]"
    assertTrue "File $MANAGER_OMT_CONF_PATH not found." "[[ -f $MANAGER_OMT_CONF_PATH ]]"
    assertTrue "File $MANAGER_OMT_LOCAL_CONF_PATH not found." "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH ]]"
}

printAndRun() {
    export output
    # echo command with green color
    echo -e "\033[32mcommand\033[0m: $*"
    # Run the command, capture the output and store the return value
    output=$("$@")
    return $?
}

cleanEnv() {
    [[ -d "$MANAGER_OMT_DIR_PATH" ]] && rm -rf "$MANAGER_OMT_DIR_PATH"
    [[ -f "$MANAGER_OMT_CONF_PATH" ]] && rm "$MANAGER_OMT_CONF_PATH"
    [[ -f "$MANAGER_OMT_LOCAL_CONF_PATH" ]] && rm "$MANAGER_OMT_LOCAL_CONF_PATH"
    [[ -f "$MANAGER_OMT_CONF_PATH.bak" ]] && rm "$MANAGER_OMT_CONF_PATH.bak"
    [[ -f "$MANAGER_OMT_LOCAL_CONF_PATH.bak" ]] && rm "$MANAGER_OMT_LOCAL_CONF_PATH.bak"
}

makeCommitInLocalRepo() {
    git -C "$MANAGER_OMT_DIR_PATH" config user.email "test@github.com"
    git -C "$MANAGER_OMT_DIR_PATH" config user.name "test"
    echo "test" >"$MANAGER_OMT_DIR_PATH/omt-manager-test"
    git -C "$MANAGER_OMT_DIR_PATH" add .
    git -C "$MANAGER_OMT_DIR_PATH" commit -m "test" --no-gpg-sign
}

# compareOutput() {
#     # we can use od to check the output in hex
#     echo "Expected output in hex:"
#     echo -n "$1" | od -t x1

#     echo "Actual output in hex:"
#     echo -n "$2" | od -t x1
# }
