#!/usr/bin/env bats

load test_helper
script=honest.bats

@test "$script: one_gadget" {
  run honest github://david942j/one_gadget --tag v1.5.0 gem:one_gadget -v 1.5.0
  [ "$status" -eq 0 ]
  result="${lines[${#lines[@]}-1]}"
  [ "$result" = "[INFO] OK, one_gadget is Honest!" ]
}
