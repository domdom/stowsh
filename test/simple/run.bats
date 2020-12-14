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
    :
}

@test "simple stow" {
    run stowsh stow "pkg" "dest"
    assert_success

    run diff -r --no-dereference "expected" "dest"
    assert_success
}

@test "simple unstow" {
    run stowsh stow "pkg" "dest"
    assert_success

    run diff -r --no-dereference "expected" "dest"
    assert_success

    run stowsh unstow "pkg" "dest"
    assert_success
    run diff -r --no-dereference "empty" "dest"
    assert_success
}

@test "nested stow" {
    run stowsh stow "pkg-nested" "dest"
    assert_success

    run diff -r --no-dereference "expected-nested" "dest"
    assert_success
}

@test "nested unstow" {
    run stowsh stow "pkg-nested" "dest"
    assert_success

    run diff -r --no-dereference "expected-nested" "dest"
    assert_success

    run stowsh unstow "pkg-nested" "dest"
    assert_success

    run diff -r --no-dereference "empty" "dest"
    assert_success
}
