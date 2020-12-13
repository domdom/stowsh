#!/usr/bin/env bash

load ../lib/test_helpers

load ../lib/bats-support/load
load ../lib/bats-assert/load

setup() {
    mkdir -p "$BATS_TEST_DIRNAME/dest"
    mkdir -p "$BATS_TEST_DIRNAME/empty"
}

teardown () {
    rm -rf "$BATS_TEST_DIRNAME/dest"
    rm -rf "$BATS_TEST_DIRNAME/empty"
}

@test "simple stow" {
    run stowsh stow "$BATS_TEST_DIRNAME/pkg" "$BATS_TEST_DIRNAME/dest"

    run diff -r --no-dereference "$BATS_TEST_DIRNAME/expected" "$BATS_TEST_DIRNAME/dest"

    refute_output
}

@test "simple unstow" {
    run stowsh stow "$BATS_TEST_DIRNAME/pkg" "$BATS_TEST_DIRNAME/dest"

    run stowsh unstow "$BATS_TEST_DIRNAME/pkg" "$BATS_TEST_DIRNAME/dest"

    run diff -r --no-dereference "$BATS_TEST_DIRNAME/empty" "$BATS_TEST_DIRNAME/dest"

    refute_output
}
