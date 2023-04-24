//
//  VideoPlayerModule.swift
//  videoplayer
//
//  Created by Cong Do Nguyen on 4/20/23.
//

import Foundation
import AVFoundation

@objc(VideoPlayerManager)
class VideoPlayerManager: RCTViewManager {
  var videoPlayerView: VideoPlayerView?
  
  override func view() -> UIView! {
    let myView = VideoPlayerView()
    videoPlayerView = myView
    return myView
  }
  
  @objc func pause() {
    videoPlayerView?.pause()
  }
  
  @objc func play() {
    videoPlayerView?.continueVideo()
  }
  
  @objc func seek(_ to: Float) {
    videoPlayerView?.seek(to: Double(to))
  }
  
  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
}
