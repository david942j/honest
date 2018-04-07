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
  run honest-clone github://david942j/honest --commit= --tag=tag_for_test --latest=
  result="${lines[-1]}"
  [ "$status" -eq 0 ]
  [ -f "$result/this_file_exists_in_this_commit_only" ]
}
