/*
 * Copyright (c) 2014 Home Box Office, Inc. as an unpublished
 * work. Neither this material nor any portion hereof may be copied or
 * distributed without the express written consent of Home Box Office, Inc.
 *
 * This material also contains proprietary and confidential information
 * of Home Box Office, Inc. and its suppliers, and may not be used by or
 * disclosed to any person, in whole or in part, without the prior written
 * consent of Home Box Office, Inc.
 */

/*! @file Log.h
 *
 * Helper functions for logging
 */

#pragma once

#include <cstring>
#include "src/android/log.h"

#define _LOG_TAG (strrchr(__FILE__, '/') + 1)
#define _LOG(level, format, ...)                            \
    __android_log_print(level, _LOG_TAG, "%s:%d: " format,  \
                        __func__, __LINE__, ##__VA_ARGS__)

#define LOG_NONE(...) do {} while (0)

#ifndef NDEBUG
# define LOG_DEBUG(...)   _LOG(ANDROID_LOG_DEBUG,   __VA_ARGS__)
# define LOG_VERBOSE(...) _LOG(ANDROID_LOG_VERBOSE, __VA_ARGS__)
#else
# define LOG_DEBUG(...)   LOG_NONE()
# define LOG_VERBOSE(...) LOG_NONE()
#endif

#define LOG_INFO(...)    _LOG(ANDROID_LOG_INFO,    __VA_ARGS__)
#define LOG_WARN(...)    _LOG(ANDROID_LOG_WARN,    __VA_ARGS__)
#define LOG_ERROR(...)   _LOG(ANDROID_LOG_ERROR,   __VA_ARGS__)
#define LOG_FATAL(...)   _LOG(ANDROID_LOG_FATAL,   __VA_ARGS__)
