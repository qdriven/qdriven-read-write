echo "please install elumator in AVD manager before installing apk, "
echo "install apk to simulator"
adb install -r $1

echo "using gradle to install, please run gradle task"


# adb install -r  anjuke_12.8.2_321884_b688.apk                   [ruby-2.4.1]
# adb: failed to install anjuke_12.8.2_321884_b688.apk: Failure [INSTALL_FAILED_NO_MATCHING_ABIS: Failed to extract native libraries, res=-113]