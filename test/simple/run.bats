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
    run stowsh -t "$dest" "pkg"
    assert_success

    run diff -r --no-dereference "expected" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg"
    assert_success
    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "single file in directory" {
    run stowsh -t "$dest" "pkg-nested"
    assert_success

    run diff -r --no-dereference "expected-nested" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg-nested"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "folder and file with . prefix" {
    run stowsh -t "$dest" "pkg-dots"
    assert_success

    run diff -r --no-dereference "expected-dots" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg-dots"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "file and symbolic link" {
    run stowsh -t "$dest" "pkg-symlink"
    assert_success

    run diff -r --no-dereference "expected-symlink" "$dest"
    assert_success

    run stowsh -D -t "$dest" "pkg-symlink"
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}

@test "unstow owned stale symbolic link" {
    # Create a stale symlink
    ln -s "../pkg/non-existent" "$dest"

    run stowsh -D -t "$dest" "pkg"
    assert_output ""
    assert_success

    run diff -r --no-dereference "empty" "$dest"
    assert_success
}
