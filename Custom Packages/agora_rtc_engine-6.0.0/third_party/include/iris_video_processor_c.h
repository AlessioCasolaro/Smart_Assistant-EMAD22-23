//
// Created by LXH on 2021/3/4.
//

#ifndef IRIS_VIDEO_PROCESSOR_C_H_
#define IRIS_VIDEO_PROCESSOR_C_H_

#include "iris_media_base_c.h"

EXTERN_C_ENTER

typedef enum IRIS_VIDEO_PROCESS_ERR {
  ERR_OK = 0,
  ERR_NULL_POINTER = 1,
  ERR_SIZE_NOT_MATCHING = 2,
  ERR_BUFFER_EMPTY = 5,
} IRIS_VIDEO_PROCESS_ERR;

typedef struct IrisVideoFrameBufferConfig {
  IrisVideoSourceType type;
  unsigned int id;
  char key[kBasicStringLength];
} IrisVideoFrameBufferConfig;

typedef void(IRIS_CALL *Func_VideoFrame)(
    const IrisVideoFrame *video_frame, const IrisVideoFrameBufferConfig *config,
    bool resize);
typedef struct IrisCVideoFrameBuffer {
  IrisVideoFrameType type;
  Func_VideoFrame OnVideoFrameReceived;
  int bytes_per_row_alignment;
} IrisCVideoFrameBuffer;

IRIS_API IrisVideoFrameBufferManagerPtr CreateIrisVideoFrameBufferManager();

IRIS_API void
FreeIrisVideoFrameBufferManager(IrisVideoFrameBufferManagerPtr manager_ptr);

IRIS_API IrisVideoFrameBufferDelegateHandle EnableVideoFrameBuffer(
    IrisVideoFrameBufferManagerPtr manager_ptr, IrisCVideoFrameBuffer *buffer,
    unsigned int uid, const char *channel_id) IRIS_DEPRECATED;

IRIS_API IrisVideoFrameBufferDelegateHandle EnableVideoFrameBufferByConfig(
    IrisVideoFrameBufferManagerPtr manager_ptr, IrisCVideoFrameBuffer *buffer,
    const IrisVideoFrameBufferConfig *config);

IRIS_API void
DisableVideoFrameBufferByDelegate(IrisVideoFrameBufferManagerPtr manager_ptr,
                                  IrisVideoFrameBufferDelegateHandle handle);

IRIS_API void DisableVideoFrameBufferByUid(
    IrisVideoFrameBufferManagerPtr manager_ptr, unsigned int uid,
    const char *channel_id,
    IrisVideoFrameBufferDelegateHandle handle) IRIS_DEPRECATED;

IRIS_API void
DisableVideoFrameBufferByConfig(IrisVideoFrameBufferManagerPtr manager_ptr,
                                const IrisVideoFrameBufferConfig *config,
                                IrisVideoFrameBufferDelegateHandle handle);

IRIS_API void
DisableAllVideoFrameBuffer(IrisVideoFrameBufferManagerPtr manager_ptr);

IRIS_API int GetVideoFrame(IrisVideoFrameBufferManagerPtr manager_ptr,
                           IrisVideoFrame *video_frame, bool *is_new_frame,
                           unsigned int uid,
                           const char *channel_id) IRIS_DEPRECATED;

IRIS_API int GetVideoFrameByConfig(IrisVideoFrameBufferManagerPtr manager_ptr,
                                   IrisVideoFrame *video_frame,
                                   bool *is_new_frame,
                                   const IrisVideoFrameBufferConfig *config);

IRIS_API bool StartDumpVideo(IrisVideoFrameBufferManagerPtr manager_ptr,
                             IrisVideoSourceType type, const char *dir);

IRIS_API bool StopDumpVideo(IrisVideoFrameBufferManagerPtr manager_ptr);

EXTERN_C_LEAVE

#endif//IRIS_VIDEO_PROCESSOR_C_H_
