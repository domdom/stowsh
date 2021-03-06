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

@test "multiple packages" {
    run stowsh -t "$dest" "pkg1"
    assert_success
    run diff -r --no-dereference "expected-1" "$dest"
    assert_success

    run stowsh -t "$dest" "pkg2"
    assert_success
    run diff -r --no-dereference "expected-3" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg1"
    assert_success
    run diff -r --no-dereference "expected-2" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg2"
    assert_success
    run diff -r --no-dereference "empty" "$dest"
    assert_success
}
