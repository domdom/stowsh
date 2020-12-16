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

@test "dot-rename disabled" {
    run stowsh -t "$dest" "pkg"
    assert_success

    run diff -r --no-dereference "expected" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "dot-rename enabled" {
    run stowsh --dot-rename -t "$dest" "pkg"
    assert_output
    assert_success

    run diff -r --no-dereference "expected-on" "$dest"
    assert_success

    run stowsh --dot-rename -D -t "$dest" "pkg"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}
