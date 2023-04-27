#!/bin/bash
source ./omt-manager.sh
source ./tests/utils.sh

testUpgrade() {
    # test upgrade
    cleanEnv
    printAndRun omt install -s
    assertOMTFileExist
    expect_output="Oh My Tmux is already up to date."
    printAndRun omt upgrade
    assertTrue $?
    assertEquals "Worng output." "$expect_output" "$output"
    assertOMTFileExist
    assertFalse "File $MANAGER_OMT_LOCAL_CONF_PATH.bak should not exist." "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH.bak ]]"

    # test upgrade with -o
    cleanEnv
    printAndRun omt install -s
    assertOMTFileExist
    # make the local repo not up to date
    makeCommitInLocalRepo
    expect_output="Oh My Tmux has been upgraded to the latest version."
    printAndRun omt upgrade -o
    assertTrue $?
    assertOMTFileExist
    assertContains "Worng output." "$expect_output" "$output"
    assertTrue "File $MANAGER_OMT_LOCAL_CONF_PATH.bak should exist." "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH.bak ]]"
}

testNotInstalled() {
    cleanEnv

    # without -s
    expect_output="Oh My Tmux is not installed."
    printAndRun omt upgrade
    assertFalse $?
    assertOMTFileNotExist
    assertEquals "Worng output." "$expect_output" "$output"

    # with -s
    expect_output=""
    printAndRun omt upgrade -s
    assertFalse $?
    assertOMTFileNotExist
    assertEquals "Worng output." "$expect_output" "$output"
}

testHelp() {
    expect_output=$'Usage: omt upgrade [-s] [-o] [-h]'
    printAndRun omt upgrade -h
    assertTrue $?
    assertContains "Worng output." "$expect_output" "$output"
}

testWrongOption() {
    expect_output=$'Usage: omt upgrade [-s] [-o] [-h]'
    printAndRun omt upgrade -x
    assertFalse $?
    assertContains "Worng output." "$expect_output" "$output"
}

testWrongRepo() {
    1.upgrade with broken repo
    cleanEnv
    omt install -s
    # remove .git
    rm -rf "$MANAGER_OMT_DIR_PATH/.git"
    expect_output=$'Failed to determine the current branch name for local Oh My Tmux.\nPlease check if it is a valid git repository.\nYou can use \"omt install -f\" to force re-install.'
    printAndRun omt upgrade
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"
    # compareOutput "$expect_output" "$output"

    # with -s
    cleanEnv
    omt install -s
    # remove .git
    rm -rf "$MANAGER_OMT_DIR_PATH/.git"
    expect_output=""
    printAndRun omt upgrade -s
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # 2.upgrade with wrong origin
    cleanEnv
    omt install -s
    # change origin
    git -C "$MANAGER_OMT_DIR_PATH" remote set-url origin https://github.com/wrong.git
    expect_output="Failed to fetch updates."
    printAndRun omt upgrade
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # with -s
    cleanEnv
    omt install -s
    # change origin
    git -C "$MANAGER_OMT_DIR_PATH" remote set-url origin https://github.com/wrong.git
    expect_output=""
    printAndRun omt upgrade -s
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # 3.upgrade with wrong local branch
    cleanEnv
    omt install -s
    # delete local branch
    local branch_name
    branch_name=$(git -C "$MANAGER_OMT_DIR_PATH" symbolic-ref --short HEAD)
    git -C "$MANAGER_OMT_DIR_PATH" checkout -b test
    git -C "$MANAGER_OMT_DIR_PATH" branch -D "$branch_name"
    expect_output="Failed to merge updates."
    printAndRun omt upgrade
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # with -s
    cleanEnv
    omt install -s
    # delete local branch
    local branch_name
    branch_name=$(git -C "$MANAGER_OMT_DIR_PATH" symbolic-ref --short HEAD)
    git -C "$MANAGER_OMT_DIR_PATH" checkout -b test
    git -C "$MANAGER_OMT_DIR_PATH" branch -D "$branch_name"
    expect_output=""
    printAndRun omt upgrade -s
    assertFalse $?
    assertEquals "Worng output." "$expect_output" "$output"

    # 4.upgrade with local repo changes
    # cleanEnv
    # omt install -s
    # # delete local branch
    # local branch_name
    # echo "test" > "$MANAGER_OMT_DIR_PATH/omt-manager-test"
    # git -C "$MANAGER_OMT_DIR_PATH" add .
    # git -C "$MANAGER_OMT_DIR_PATH" commit -m "test"
    # expect_output="Failed to merge updates."
    # printAndRun omt upgrade
    # assertFalse $?
    # assertEquals "Worng output." "$expect_output" "$output"
}

# Load shUnit2.
# shellcheck disable=SC1091
. shunit2
