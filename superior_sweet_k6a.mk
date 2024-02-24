#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from sweet_k6a device
$(call inherit-product, device/xiaomi/sweet_k6a/device.mk)

# Inherit some common LineageOS stuff
$(call inherit-product, vendor/superior/config/common.mk)

# Superior flags
TARGET_SUPPORTS_BLUR := true
SYSTEM_OPTIMIZE_JAVA := true
SYSTEMUI_OPTIMIZE_JAVA := true
TARGET_BOOT_ANIMATION_RES := 1080
BUILD_WITH_GAPPS := true
SUPERIOR_OFFICIAL := true

PRODUCT_NAME := superior_sweet_k6a
PRODUCT_DEVICE := sweet_k6a
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := Redmi Note 12 Pro
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
