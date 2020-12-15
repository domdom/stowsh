#!/usr/bin/env bash

load ../test_helpers

load ../../lib/bats-support/load
load ../../lib/bats-assert/load

setup() {
    dest="dest-$BATS_TEST_NUMBER"
    mkdir -p $dest
    mkdir -p empty
}

teardown () {
    rm -rf $dest
    rmdir empty
    unset dest
}

@test "spaces in names" {
    run stowsh stow "pkg space" "$dest"
    assert_success

    run diff -r --no-dereference "expected" "$dest"
    assert_success

    run stowsh unstow "pkg space" "$dest"
    assert_success
    run diff -r --no-dereference "empty" "$dest"
    assert_success
}
