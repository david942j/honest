#!/usr/bin/env bats

load test_helper
script=honest.bats

@test "$script: version" {
  run honest --version
  [ "$status" -eq 0 ]
  [ "${output:0:15}" = "Honest version " ]
}

@test "$script: invalid format" {
  run honest / wtf:orz
  [ "$status" -eq 1 ]
  result="${lines[${#lines[@]}-1]}"
  [ "$result" = "[ERROR] Protocol 'wtf' is not supported" ]
}

@test "$script: one_gadget" {
  run honest github:david942j/one_gadget gem:one_gadget -v 1.5.0
  [ "$status" -eq 0 ]
  result="${lines[${#lines[@]}-1]}"
  [ "$result" = "[INFO] OK, one_gadget is Honest!" ]
}
