#!/usr/bin/env bats

load test_helper
script=honest.bats

@test "$script: version" {
  run honest --version
  [ "$status" -eq 0 ]
  [ "${output:0:15}" = "Honest Version " ]
}

@test "$script: invalid package" {
  run honest / wtf
  [ "$status" -eq 2 ]
  result="${lines[${#lines[@]}-1]}"
  [ "$result" = "[ERROR] Invalid package name \"wtf\", see examples." ]
}

@test "$script: one_gadget" {
  run honest github:david942j/one_gadget@v1.5.0 gem:one_gadget -v 1.5.0
  [ "$status" -eq 0 ]
  result="${lines[${#lines[@]}-1]}"
  [ "$result" = "[INFO] OK, one_gadget is Honest!" ]
}
