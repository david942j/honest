#!/usr/bin/env bats

load test_helper
script=pip.bats

setup() {
  command -v pip >/dev/null || skip "No pip installed"
  return 0
}

@test "$script: setuptools" {
  tmp_dir=$(helper_make_tmp_dir)
  run honest-pip pip:setuptools $tmp_dir -v 39.2.0
  [ "$status" -eq 0 ]
  [ -f "$tmp_dir/data/setuptools-39.2.0.dist-info/RECORD" ]
}
