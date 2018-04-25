#!/usr/bin/env bats

load test_helper
script=clone.bats
@test "$script: usage" {
  run honest-clone
  [ "$status" -eq 0 ]
  [ "${lines[0]:0:15}" = "Honest version " ]
  [ "${lines[1]}" = "Usage: honest-clone <git-url> [--quiet]" ]
}

@test "$script: invalid" {
  run honest-clone zz
  [ "$status" -eq 1 ]
  [ "$output" = "[ERROR] Repo format error - missing separater ':' or '/'" ]
}

@test "$script: invalid repo vendor" {
  run honest-clone zz:aa/bb
  [ "$status" -eq 1 ]
  [ "$output" = "[ERROR] Vendor of repo 'zz' is currently not supported" ]
}

@test "$script: fetch tag" {
  [ -z "$CI"] && skip "cloning takes long time"
  run honest-clone github:david942j/honest@tag_for_test
  # bash on macOS too old, doesn't support ary[-1]
  result="${lines[${#lines[@]}-1]}"
  [ "$status" -eq 0 ]
  [ -f "$result/this_file_exists_in_this_commit_only" ]
}
