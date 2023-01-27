//
// Created by LXH on 2022/5/17.
//

#ifndef IRIS_IRIS_VIDEO_PROCESSOR_CXX_H
#define IRIS_IRIS_VIDEO_PROCESSOR_CXX_H

#include "iris_video_processor_c.h"

namespace agora {
namespace iris {

class IrisVideoFrameBufferDelegate {
 public:
  virtual void OnVideoFrameReceived(const IrisVideoFrame &video_frame,
                                    const IrisVideoFrameBufferConfig *config,
                                    bool resize) = 0;
};

class IRIS_CPP_API IrisVideoFrameBuffer : public IrisVideoFrame {
 public:
  explicit IrisVideoFrameBuffer(
      IrisVideoFrameType type, IrisVideoFrameBufferDelegate *delegate = nullptr,
      int bytes_per_row_alignment = 2);

 public:
  IrisVideoFrameBufferDelegate *delegate;
  int bytes_per_row_alignment;
};

class IRIS_CPP_API IrisVideoFrameBufferManager {
 public:
  IrisVideoFrameBufferManager();
  virtual ~IrisVideoFrameBufferManager();

  /**
   * Enable buffer the video frame from user.
   * @param buffer The video frame buffer.
   * @param uid The user ID you want to cache.
   * @param channel_id The channel ID.
   */
  void EnableVideoFrameBuffer(const IrisVideoFrameBuffer &buffer,
                              unsigned int uid,
                              const char *channel_id = "") IRIS_DEPRECATED;

  void DisableVideoFrameBuffer(const IrisVideoFrameBufferDelegate *delegate);

  void DisableVideoFrameBuffer(const unsigned int *uid = nullptr,
                               const char *channel_id = "") IRIS_DEPRECATED;

  int GetVideoFrame(IrisVideoFrame &video_frame, bool &is_new_frame,
                    unsigned int uid,
                    const char *channel_id = "") IRIS_DEPRECATED;

 public:
  /**
   * Enable buffer the video frame from user.
   * @param buffer The video frame buffer.
   * @param config The video frame buffer config.
   */
  void EnableVideoFrameBuffer(const IrisVideoFrameBuffer &buffer,
                              const IrisVideoFrameBufferConfig *config);

  void
  DisableVideoFrameBuffer(const IrisVideoFrameBufferConfig *config = nullptr);

  int GetVideoFrame(IrisVideoFrame &video_frame, bool &is_new_frame,
                    const IrisVideoFrameBufferConfig *config);

 public:
  bool SetVideoFrameInternal(const IrisVideoFrame &video_frame,
                             const IrisVideoFrameBufferConfig *config);

  bool GetVideoFrameInternal(IrisVideoFrame &video_frame,
                             const IrisVideoFrameBufferConfig *config);

  bool StartDumpVideo(IrisVideoSourceType type, const char *dir);

  bool StopDumpVideo();

 private:
  class Impl;
  Impl *impl_;
};

}// namespace iris
}// namespace agora

#endif//IRIS_IRIS_VIDEO_PROCESSOR_CXX_H
