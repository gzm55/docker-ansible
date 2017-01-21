#!/bin/sh

test ":$DEBUG" = :true && set -x
set -e

cd -- "`dirname $0`"
for f in test-*.sh; do
  test ":$f" != ":`basename $0`" && . "./$f"
done
