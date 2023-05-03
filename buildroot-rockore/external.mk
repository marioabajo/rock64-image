include $(sort $(wildcard $(BR2_EXTERNAL_ROCKORE_BR_PATH)/package/*/*.mk))
ARM_TRUSTED_FIRMWARE_MAKE_ENV += $(TARGET_MAKE_ENV) LDFLAGS=--no-warn-rwx-segment
