#!/usr/bin/env bats

load test_helper
script=gem.bats

@test "$script: unexist gem" {
  [ -z "$CI" ] && skip "fetching unexist gem takes long time.."
  run honest-gem gem:_this_gem_should_never_exist_ $(helper_make_tmp_dir)
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "[ERROR] ERROR:  Could not find a valid gem '_this_gem_should_never_exist_' (>= 0) in any repository" ]
}

@test "$script: one_gadget" {
  tmp_dir=$(helper_make_tmp_dir)
  run honest-gem gem:one_gadget $tmp_dir
  [ "$status" -eq 0 ]
  [ -f "$tmp_dir/metadata" ]
}
