//
//  VideoPlayerModule.m
//  videoplayer
//
//  Created by Cong Do Nguyen on 4/20/23.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTViewManager.h"

@interface RCT_EXTERN_MODULE(VideoPlayerManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(videoUrl, NSString)
RCT_EXPORT_VIEW_PROPERTY(onLoaded, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onCurrentTimeChange, RCTDirectEventBlock)
RCT_EXTERN_METHOD(pause)
RCT_EXTERN_METHOD(play)
RCT_EXTERN_METHOD(seek: (float *) to)
@end
