#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

export DEVICE=sweet_k6a
export VENDOR=xiaomi

# Load extract utilities and do some sanity checks.
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction.
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/bin/mi_thermald)
            sed -i 's/%d\/on/%d\/../g' "${2}"
        ;;
        vendor/lib64/vendor.xiaomi.hardware.citsensorservice@1.0.so | vendor/lib64/vendor.xiaomi.hardware.citsensorservice@1.0_vendor.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
        ;;
        vendor/lib64/camera/components/com.qti.node.watermark.so)
            "${PATCHELF}" --add-needed "libpiex_shim.so" "${2}"
        ;;
        vendor/lib64/hw/hwcomposer.sm6150.so)
            "${PATCHELF}" --add-needed "libsdmcore-shim.so" "${2}"
        ;;

        vendor/lib64/libdlbdsservice.so | vendor/lib/libstagefright_soft_ac4dec.so | vendor/lib/libstagefright_soft_ddpdec.so)
        "${PATCHELF}" --replace-needed "libstagefright_foundation.so" "libstagefright_foundation-v33.so" "${2}"
        ;;
    esac
}

# Initialize the helper.
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"
extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
