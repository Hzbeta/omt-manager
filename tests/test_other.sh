#!/bin/bash
source ./omt-manager.sh
source ./tests/utils.sh

testHelp() {
    expect_output="Usage: omt [install|remove|upgrade]"
    printAndRun omt -h
    assertTrue "When the -h parameter is called, the exit code is not 0, but 1." $?
    assertContains "Worng output." "$expect_output" "$output"
}

testWorngArgs() {
    # be careful with the output, use this format to handle \n
    expect_output=$'Usage: omt [install|remove|upgrade]'
    printAndRun omt worng_args
    assertFalse "When the wrong parameter is called, the exit code is not 1, but 0." $?
    assertContains "Worng output." "$expect_output" "$output"
}

# Load shUnit2.
# shellcheck disable=SC1091
. shunit2
