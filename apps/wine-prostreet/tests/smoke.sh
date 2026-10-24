#!/usr/bin/env bash
source /smoke-common/lib.sh

assert_has wine
assert_has winetricks
assert_path /opt/wineprefix-template
assert_path /wineprefix
assert_path /opt/gow/startup-app.sh

smoke_report
