//
// Created by LXH on 2021/7/20.
//

#ifndef IRIS_MEDIA_BASE_C_H_
#define IRIS_MEDIA_BASE_C_H_

#include "iris_base.h"
#include <stdint.h>

EXTERN_C_ENTER

typedef enum IrisVideoFrameType {
  kVideoFrameTypeYUV420,
  kVideoFrameTypeYUV422,
  kVideoFrameTypeRGBA,
  kVideoFrameTypeBGRA,
} IrisVideoFrameType;

typedef enum IrisVideoSourceType {
  kVideoSourceTypeCameraPrimary,
  kVideoSourceTypeCameraSecondary,
  kVideoSourceTypeScreenPrimary,
  kVideoSourceTypeScreenSecondary,
  kVideoSourceTypeCustom,
  kVideoSourceTypeMediaPlayer,
  kVideoSourceTypeRtcImagePng,
  kVideoSourceTypeRtcImageJpeg,
  kVideoSourceTypeRtcImageGif,
  kVideoSourceTypeRemote,
  kVideoSourceTypeTranscoded,
  kVideoSourceTypePreEncode,
  kVideoSourceTypePreEncodeSecondaryCamera,
  kVideoSourceTypePreEncodeScreen,
  kVideoSourceTypePreEncodeSecondaryScreen,
  kVideoSourceTypeUnknown,
} IrisVideoSourceType;

typedef struct IrisVideoFrame {
  IrisVideoFrameType type;
  int width;
  int height;
  int y_stride;
  int u_stride;
  int v_stride;
  void *y_buffer;
  void *u_buffer;
  void *v_buffer;
  unsigned int y_buffer_length;
  unsigned int u_buffer_length;
  unsigned int v_buffer_length;
  int rotation;
  int64_t render_time_ms;
  int av_sync_type;
  void *metadata_buffer;
  int metadata_size;
  void *sharedContext;
  int textureId;
  float matrix[16];
} IrisVideoFrame;

typedef enum IRIS_VIDEO_SOURCE_TYPE {
  /** Video captured by the camera.
   */
  IRIS_VIDEO_SOURCE_CAMERA_PRIMARY,
  IRIS_VIDEO_SOURCE_CAMERA = IRIS_VIDEO_SOURCE_CAMERA_PRIMARY,
  /** Video captured by the secondary camera.
   */
  IRIS_VIDEO_SOURCE_CAMERA_SECONDARY,
  /** Video for screen sharing.
   */
  IRIS_VIDEO_SOURCE_SCREEN_PRIMARY,
  IRIS_VIDEO_SOURCE_SCREEN = IRIS_VIDEO_SOURCE_SCREEN_PRIMARY,
  /** Video for secondary screen sharing.
   */
  IRIS_VIDEO_SOURCE_SCREEN_SECONDARY,
  /** Not define.
   */
  IRIS_VIDEO_SOURCE_CUSTOM,
  /** Video for media player sharing.
   */
  IRIS_VIDEO_SOURCE_MEDIA_PLAYER,
  /** Video for png image.
   */
  IRIS_VIDEO_SOURCE_RTC_IMAGE_PNG,
  /** Video for png image.
   */
  IRIS_VIDEO_SOURCE_RTC_IMAGE_JPEG,
  /** Video for png image.
   */
  IRIS_VIDEO_SOURCE_RTC_IMAGE_GIF,
  /** Remote video received from network.
   */
  IRIS_VIDEO_SOURCE_REMOTE,
  /** Video for transcoded.
   */
  IRIS_VIDEO_SOURCE_TRANSCODED,

  IRIS_VIDEO_SOURCE_UNKNOWN = 100
} IRIS_VIDEO_SOURCE_TYPE;

typedef struct IrisMetadata {
  unsigned int uid;

  unsigned int size;

  unsigned char *buffer;

  long long timeStampMs;
} IrisMetadata;

IRIS_API const struct IrisVideoFrame IrisVideoFrame_default;

IRIS_API void ResizeVideoFrame(IrisVideoFrame *video_frame);

IRIS_API void ClearVideoFrame(IrisVideoFrame *video_frame);

IRIS_API bool CopyVideoFrame(IrisVideoFrame *dst, const IrisVideoFrame *src,
                             bool deepCopy);

IRIS_API bool ConvertVideoFrame(IrisVideoFrame *dst, const IrisVideoFrame *src);

typedef struct IrisPacket {
  const unsigned char *buffer;
  unsigned int size;
} IrisPacket;
typedef enum IRIS_VIDEO_PIXEL_FORMAT {
  /**
   * 0: Default format.
   */
  IRIS_VIDEO_PIXEL_DEFAULT = 0,
  /**
   * 1: I420.
   */
  IRIS_VIDEO_PIXEL_I420 = 1,
  /**
   * 2: BGRA.
   */
  IRIS_VIDEO_PIXEL_BGRA = 2,
  /**
   * 3: NV21.
   */
  IRIS_VIDEO_PIXEL_NV21 = 3,
  /**
   * 4: RGBA.
   */
  IRIS_VIDEO_PIXEL_RGBA = 4,
  /**
   * 8: NV12.
   */
  IRIS_VIDEO_PIXEL_NV12 = 8,
  /**
   * 10: GL_TEXTURE_2D
   */
  VIDEO_TEXTURE_2D = 10,
  /**
   * 11: GL_TEXTURE_OES
   */
  VIDEO_TEXTURE_OES = 11,
  /*
  12: pixel format for iOS CVPixelBuffer NV12
  */
  IRIS_VIDEO_CVPIXEL_NV12 = 12,
  /*
  13: pixel format for iOS CVPixelBuffer I420
  */
  IRIS_VIDEO_CVPIXEL_I420 = 13,
  /*
  14: pixel format for iOS CVPixelBuffer BGRA
  */
  IRIS_VIDEO_CVPIXEL_BGRA = 14,
  /**
   * 16: I422.
   */
  IRIS_IRIS_VIDEO_PIXEL_I422 = 16,
} IRIS_VIDEO_PIXEL_FORMAT;
EXTERN_C_LEAVE

#endif//IRIS_MEDIA_BASE_C_H_
