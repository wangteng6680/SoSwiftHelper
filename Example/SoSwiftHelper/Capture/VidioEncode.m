//
//  VidioEncode.m
//  SoSwiftHelper_Example
//
//  Created by wangteng on 2020/7/13.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

#import "VidioEncode.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>

@interface VidioEncode()

@property (nonatomic, assign) VTCompressionSessionRef EncodingSession;

@end

void didCompressH264(void * CM_NULLABLE outputCallbackRefCon,
                     void * CM_NULLABLE sourceFrameRefCon,
                     OSStatus status,
                     VTEncodeInfoFlags infoFlags,
                     CM_NULLABLE CMSampleBufferRef sampleBuffer) {
    
}

@implementation VidioEncode

-(void)encode:(CMSampleBufferRef)sampleBuffer {
    
    OSStatus status = [self prepare];
    
    CVImageBufferRef imageBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    // 帧时间，如果不设置会导致时间轴过长。
    CMTime presentationTimeStamp = CMTimeMake(frameID++, 1000);
    VTEncodeInfoFlags flags;
    OSStatus statusCode = VTCompressionSessionEncodeFrame(_EncodingSession,
                                                          imageBuffer,
                                                          presentationTimeStamp,
                                                          kCMTimeInvalid,
                                                          NULL, NULL, &flags);
}


-(OSStatus)prepare{
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = UIScreen.mainScreen.bounds.size.width;
    OSStatus status = VTCompressionSessionCreate(NULL,
                                                 width,
                                                 height,
                                                 kCMVideoCodecType_H264,
                                                 NULL,
                                                 NULL,
                                                 NULL,
                                                 didCompressH264,
                                                 (__bridge void *)(self),
                                                 &_EncodingSession);
    /// 实时编码
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    
    /// 编码级别
    VTSessionSetProperty(_EncodingSession, kVTProfileLevel_H264_Baseline_AutoLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    
    /// 是否产生B帧（直播时不需要B帧）
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
    
    /// 设置关键帧（GOPsize)间隔
    int frameInterval = 10;
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    
    /// 设置期望帧率
    int fps = 10;
    CFNumberRef  fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    
    /// 设置码率，上限，单位是bps
    int bitRate = width * height * 3 * 4 * 8;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_AverageBitRate, bitRateRef);
    
    /// 设置码率，均值，单位是byte
    int bitRateLimit = width * height * 3 * 4;
    CFNumberRef bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRateLimit);
    VTSessionSetProperty(_EncodingSession, kVTCompressionPropertyKey_DataRateLimits, bitRateLimitRef);
    
    //􏱂􏲨􏱵􏱶 开始编码
    VTCompressionSessionPrepareToEncodeFrames(_EncodingSession);
    
    return status;
}

@end
