#!/bin/bash
source ./omt-manager.sh
source ./tests/utils.sh

clean_install() {
    cleanEnv
    printAndRun "$@"
    assertTrue $?
    assertOMTFileExist
}

# clean install
testCleanInstall() {
    # without any option
    clean_install omt install

    # with -f option
    clean_install omt install -f

    # with -s option
    clean_install omt install -s

    # with -fo option
    clean_install omt install -fo
}

# dirty install
testDirtyInstall() {
    # 1. install without -f option
    cleanEnv

    # install
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # install again
    expect_output=$'Oh My Tmux already exists or .tmux.conf is present. Use -f option to force install.'
    printAndRun omt install
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"
    assertOMTFileExist

    # install again with -s option
    expect_output=""
    printAndRun omt install -s
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # 2. install with -f option
    cleanEnv

    # install
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # install again
    expect_output=$'.tmux.conf.local already exists. Use -fo options to to backup and overwrite it.'
    printAndRun omt install -f
    assertFalse $?
    assertOMTFileExist
    assertEquals "Worng output." "$expect_output" "$output"
    assertTrue ".tmux.conf bakup file not exist" "[[ -f $MANAGER_OMT_CONF_PATH.bak ]]"
    assertFalse ".tmux.conf.local bakup file found" "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH.bak ]]"

    # 3. install with -fs option
    cleanEnv

    # install
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # install again
    expect_output=""
    printAndRun omt install -fs
    assertFalse $?
    assertOMTFileExist
    assertEquals "Worng output." "$expect_output" "$output"
    assertTrue ".tmux.conf bakup file not exist" "[[ -f $MANAGER_OMT_CONF_PATH.bak ]]"
    assertFalse ".tmux.conf.local bakup file found" "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH.bak ]]"

    # 4. install with -fo option
    cleanEnv

    # install
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # install again
    expect_output=""
    printAndRun omt install -fo
    assertTrue $?
    assertOMTFileExist
    assertEquals "Worng output." "$expect_output" "$output"
    assertTrue "omt install -f" "[[ -f $MANAGER_OMT_CONF_PATH.bak ]]"
    assertTrue "omt install -fo" "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH.bak ]]"
}

# costom install dir
testCustomInstallDir() {

    # 1. install with right custom dir
    cleanEnv

    export MANAGER_OMT_DIR_PATH="$HOME/custom/.omt"
    export MANAGER_OMT_CONF_PATH="$HOME/.config/tmux.conf"
    export MANAGER_OMT_LOCAL_CONF_PATH="$HOME/.config/tmux.conf.local"
    # install with custom dir
    printAndRun omt install
    assertTrue "[Failed][CustomInstallDir] omt install with costom dir" $?
    assertOMTFileExist

    # remove
    cleanEnv

    # 2. install with no permission path
    export MANAGER_OMT_DIR_PATH="/root/.config/tmux"
    export MANAGER_OMT_CONF_PATH="/root/.config/tmux.conf"
    export MANAGER_OMT_LOCAL_CONF_PATH="/root/.config/tmux.conf.local"
    expect_output=$'Failed to create directory /root/.config.'
    printAndRun omt install
    assertFalse "[Failed][CustomInstallDir] omt install with no permission path" $?
    assertEquals "Worng output." "$expect_output" "$output"
    assertOMTFileNotExist

    # restore the environment
    export MANAGER_OMT_DIR_PATH="$HOME/.omt"
    export MANAGER_OMT_CONF_PATH="$HOME/.tmux.conf"
    export MANAGER_OMT_LOCAL_CONF_PATH="$HOME/.tmux.conf.local"
}

testHelp() {
    expect_output=$'Usage: omt install [-s] [-f] [-o] [-h]'
    printAndRun omt install -h
    assertTrue "[Failed][Help] omt install -h" $?
    assertContains "Worng output." "$expect_output" "$output"
}

testWrongOption() {
    expect_output=$'Usage: omt install [-s] [-f] [-o] [-h]'
    printAndRun omt install -x
    assertFalse "[Failed][WrongOption] omt install -x" $?
    assertContains "Worng output." "$expect_output" "$output"

    expect_output=$'The -o option must be used with -f.'
    printAndRun omt install -o
    assertFalse "[Failed][WrongOption] omt install -o" $?
    assertEquals "Worng output." "$expect_output" "$output"
}

testWrongRepo() {
    # install with no internet
    cleanEnv
    expect_output="Failed to clone Oh My Tmux repository."
    export MANAGER_OMT_REPO_URL="https://github.com/wrong.git"
    printAndRun omt install
    assertFalse $?
    assertEquals "Wrong output." "$expect_output" "$output"
    assertOMTFileNotExist

    # install with -s
    cleanEnv
    expect_output=""
    export MANAGER_OMT_REPO_URL="https://github.com/wrong.git"
    printAndRun omt install -s
    assertFalse $?
    assertEquals "Wrong output." "$expect_output" "$output"
    assertOMTFileNotExist

    # restore the environment
    export MANAGER_OMT_REPO_URL="https://github.com/gpakosz/.tmux.git"
}

# Load shUnit2.
# shellcheck disable=SC1091
. shunit2
