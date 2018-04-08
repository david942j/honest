#!/usr/bin/env bats

load test_helper
script=clone.bats
@test "$script: usage" {
  run honest-clone
  [ "$status" -eq 1 ]
  [ "$output" = "Usage: honest-clone <vendor>://<author>/<repo> --commit= --tag= --latest=" ]
}

@test "$script: invalid" {
  run honest-clone zz
  [ "$status" -eq 1 ]
}

@test "$script: invalid vendor" {
  run honest-clone qqpie --commit= --tag= --latest=
  [ "$status" -eq 1 ]
  [ "$output" = "honest-clone: Error: expected \"qqpie\" to start with \"github://\"" ]
}

@test "$script: fetch tag" {
  [ -z "$CI"] && skip "cloning takes long time"
  run honest-clone github://david942j/honest --commit= --tag=tag_for_test --latest=
  # bash on macOS too old, doesn't support ary[-1]
  result="${lines[${#lines[@]}-1]}"
  [ "$status" -eq 0 ]
  [ -f "$result/this_file_exists_in_this_commit_only" ]
}
