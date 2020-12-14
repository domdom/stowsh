#!/usr/bin/env bash

load ../test_helpers

load ../../lib/bats-support/load
load ../../lib/bats-assert/load

setup() {
    mkdir -p dest
    mkdir -p empty
}

teardown () {
    rm -rf dest
    rmdir empty
}

@test "simple stow" {
    run stowsh stow "pkg" "dest"

    run diff -r --no-dereference "expected" "dest"

    assert_output
}

@test "simple unstow" {
    run stowsh stow "pkg" "dest"
    run stowsh unstow "pkg" "dest"

    run diff -r --no-dereference "empty" "dest"

    refute_output
}
