#!/usr/bin/env bats

load test_helper
script=gem.bats

@test "$script: unexist gem" {
  [ -z "$CI"] && skip "fetching unexist gem takes long time.."
  run honest-gem download _this_gem_should_never_exist_
  [ "$status" -eq 1 ]
  [ "${lines[1]}" = "[ERROR] ERROR:  Could not find a valid gem '_this_gem_should_never_exist_' (>= 0) in any repository" ]
}
@test "$script: one_gadget" {
  run honest-gem download one_gadget
  [ "$status" -eq 0 ]
  [ -f "$output/metadata" ]
}
