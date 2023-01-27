//
// Created by LXH on 2021/3/1.
//

#ifndef IRIS_RTC_RAW_DATA_H_
#define IRIS_RTC_RAW_DATA_H_

#include "iris_media_base_cxx.h"
#include "iris_module.h"
#include "iris_queue.h"
#include "iris_rtc_base.h"
#include "iris_video_processor_c.h"
namespace agora {
namespace media {
class IVideoFrameObserver;
}
namespace iris {
class IrisVideoFrameBufferManager;
namespace rtc {
class VideoFrameObserver;

class IRIS_CPP_API IrisRtcRawData {
 public:
  explicit IrisRtcRawData(
      QueueBase<agora::media::IVideoFrameObserver> &raw_video_observer);
  ~IrisRtcRawData();

  void Initialize();

  void Release();

  void Attach(IrisVideoFrameBufferManager *manager);

 private:
  QueueBase<agora::media::IVideoFrameObserver> &raw_video_observer_;
  agora::media::IVideoFrameObserver *video_observer_;
};

}// namespace rtc
}// namespace iris
}// namespace agora

#endif//IRIS_RTC_RAW_DATA_H_
