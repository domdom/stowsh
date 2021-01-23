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

@test "file exists" {
    # This file exists in pkg
    touch "$dest/file"

    run stowsh -t "$dest" "pkg"
    assert_failure

    run diff -r --no-dereference "expected" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg"
    assert_success

    run diff -r --no-dereference "expected" "$dest"
    assert_success
}
