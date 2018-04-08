#!/usr/bin/env bats

load test_helper
script=clone.bats
@test "$script: usage" {
  run honest-clone
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: honest-clone <git-url>" ]
}

@test "$script: invalid" {
  run honest-clone zz
  [ "$status" -eq 128 ]
  [ "$output" = "fatal: repository 'zz' does not exist" ]
}

@test "$script: fetch tag" {
  [ -z "$CI"] && skip "cloning takes long time"
  run honest-clone github:david942j/honest@tag_for_test
  # bash on macOS too old, doesn't support ary[-1]
  result="${lines[${#lines[@]}-1]}"
  [ "$status" -eq 0 ]
  [ -f "$result/this_file_exists_in_this_commit_only" ]
}
