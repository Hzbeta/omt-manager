#!/bin/bash
source ./omt-manager.sh
source ./tests/utils.sh

testRemove() {
    cleanEnv

    # clean install
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # remove
    printAndRun omt remove -a
    assertOMTFileNotExist

    # clean install again
    printAndRun omt install -s
    assertTrue $?
    assertOMTFileExist

    # remove without -a
    printAndRun omt remove
    assertTrue $?
    assertFalse "Dir $MANAGER_OMT_DIR_PATH found." "[[ -d $MANAGER_OMT_DIR_PATH ]]"
    assertFalse "File $MANAGER_OMT_CONF_PATH found." "[[ -f $MANAGER_OMT_CONF_PATH ]]"
    assertTrue "File $MANAGER_OMT_LOCAL_CONF_PATH should exist." "[[ -f $MANAGER_OMT_LOCAL_CONF_PATH ]]"
}

testHelp() {
    expect_output=$'Usage: omt remove [-a] [-h]'
    printAndRun omt remove -h
    assertTrue "[Failed][Help] omt install -h" $?
    assertContains "Worng output." "$expect_output" "$output"
}

testWrongOption() {
    expect_output=$'Usage: omt remove [-a] [-h]'
    printAndRun omt remove -x
    assertFalse "[Failed][WrongOption] omt install -x" $?
    assertContains "Worng output." "$expect_output" "$output"
}

# Load shUnit2.
# shellcheck disable=SC1091
. shunit2
