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

@test "single file" {
    run stowsh stow "pkg" "$dest"
    assert_success

    run diff -r --no-dereference "expected" "$dest"
    assert_success

    run stowsh unstow "pkg" "$dest"
    assert_success
    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "single file in directory" {
    run stowsh stow "pkg-nested" "$dest"
    assert_success

    run diff -r --no-dereference "expected-nested" "$dest"
    assert_success

    run stowsh unstow "pkg-nested" "$dest"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "folder and file with . prefix" {
    run stowsh stow "pkg-dots" "$dest"
    assert_success

    run diff -r --no-dereference "expected-dots" "$dest"
    assert_success

    run stowsh unstow "pkg-dots" "$dest"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "file and symbolic link" {
    run stowsh stow "pkg-symlink" "$dest"
    assert_success

    run diff -r --no-dereference "expected-symlink" "$dest"
    assert_success

    run stowsh unstow "pkg-symlink" "$dest"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}
