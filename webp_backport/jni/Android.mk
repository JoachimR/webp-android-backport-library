LOCAL_PATH := $(call my-dir)

WEBP_CFLAGS := -Wall -DANDROID -DHAVE_MALLOC_H -DHAVE_PTHREAD -DWEBP_USE_THREAD

ifeq ($(APP_OPTIM),release)
  WEBP_CFLAGS += -finline-functions -ffast-math \
                 -ffunction-sections -fdata-sections
  ifeq ($(findstring clang,$(NDK_TOOLCHAIN_VERSION)),)
    WEBP_CFLAGS += -frename-registers -s
  endif
endif

include $(CLEAR_VARS)

ifneq ($(findstring armeabi-v7a, $(TARGET_ARCH_ABI)),)
  # Setting LOCAL_ARM_NEON will enable -mfpu=neon which may cause illegal
  # instructions to be generated for armv7a code. Instead target the neon code
  # specifically.
  NEON := c.neon
else
  NEON := c
endif

LOCAL_SRC_FILES := \
    src/dec/alpha.c \
    src/dec/buffer.c \
    src/dec/frame.c \
    src/dec/idec.c \
    src/dec/io.c \
    src/dec/quant.c \
    src/dec/tree.c \
    src/dec/vp8.c \
    src/dec/vp8l.c \
    src/dec/webp.c \
    src/dsp/alpha_processing.c \
    src/dsp/alpha_processing_sse2.c \
    src/dsp/cpu.c \
    src/dsp/dec.c \
    src/dsp/dec_clip_tables.c \
    src/dsp/dec_mips32.c \
    src/dsp/dec_neon.$(NEON) \
    src/dsp/dec_sse2.c \
    src/dsp/lossless.c \
    src/dsp/lossless_mips32.c \
    src/dsp/lossless_neon.$(NEON) \
    src/dsp/lossless_sse2.c \
    src/dsp/upsampling.c \
    src/dsp/upsampling_neon.$(NEON) \
    src/dsp/upsampling_sse2.c \
    src/dsp/yuv.c \
    src/dsp/yuv_mips32.c \
    src/dsp/yuv_sse2.c \
    src/utils/bit_reader.c \
    src/utils/bit_writer.c \
    src/utils/color_cache.c \
    src/utils/filters.c \
    src/utils/huffman.c \
    src/utils/huffman_encode.c \
    src/utils/quant_levels.c \
    src/utils/quant_levels_dec.c \
    src/utils/random.c \
    src/utils/rescaler.c \
    src/utils/thread.c \
    src/utils/utils.c \
    swig/libwebp_java_wrap.c \

LOCAL_CFLAGS := $(WEBP_CFLAGS)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/src

# prefer arm over thumb mode for performance gains
LOCAL_ARM_MODE := arm

LOCAL_STATIC_LIBRARIES := cpufeatures

LOCAL_MODULE := webp

#ifeq ($(ENABLE_SHARED),1)
  include $(BUILD_SHARED_LIBRARY)
#else
#  include $(BUILD_STATIC_LIBRARY)
#endif

# include $(LOCAL_PATH)/examples/Android.mk

$(call import-module,android/cpufeatures)
