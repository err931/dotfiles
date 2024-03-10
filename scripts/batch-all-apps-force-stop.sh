#!/bin/env bash
set -euo pipefail

adb shell pm list packages -3 | cut -d":" -f2 | tr -d \\r | xargs -L1 adb shell am force-stop && {
  adb reboot
}
