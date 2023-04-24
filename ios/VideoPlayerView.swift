//
//  VideoPlayerView.swift
//  videoplayer
//
//  Created by Cong Do Nguyen on 4/20/23.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class VideoPlayerView: UIView {
  private var playerItem: AVPlayerItem?
  private var playerItemContext = 0
  private var timeObserverToken: Any?
  
  @objc var duration: Double = 0
  @objc var onLoaded: RCTDirectEventBlock?
  @objc var onCurrentTimeChange: RCTDirectEventBlock?
  
  @objc var player: AVPlayer? {
    get {
      return playerLayer.player
    }
    set {
      playerLayer.player = newValue
    }
  }
  
  @objc var videoUrl: NSString? {
    didSet {
      NSLog(videoUrl! as String)
      guard let url = URL(string: videoUrl! as String) else { return }
      play(with: url)
    }
  }
  
  @objc var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  
  private func setUpAsset(with url: URL, completion: ((_ asset: AVAsset) -> Void)?) {
    let asset = AVAsset(url: url)
    asset.loadValuesAsynchronously(forKeys: ["playable"]) {
      var error: NSError? = nil
      let status = asset.statusOfValue(forKey: "playable", error: &error)
      switch status {
      case .loaded:
        completion?(asset)
      case .failed:
        print(".failed")
      case .cancelled:
        print(".cancelled")
      default:
        print("default")
          }
      }
  }
  
  private func setUpPlayerItem(with asset: AVAsset) {
    playerItem = AVPlayerItem(asset: asset)
    playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
    
    DispatchQueue.main.async { [weak self] in
      self?.player = AVPlayer(playerItem: self?.playerItem!)
    }
  }
  
  func addPeriodicTimeObserver() {
      // Invoke callback every second
      let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      // Add time observer. Invoke closure on the main queue.
      timeObserverToken =
          player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
              [weak self] time in
              // update player current time
            self?.onCurrentTimeChange!(["durationInSeconds": time.seconds])
      }
  }
  
  func removePeriodicTimeObserver() {
      // If a time observer exists, remove it
      if let token = timeObserverToken {
          player?.removeTimeObserver(token)
          timeObserverToken = nil
      }
  }

  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    // Only handle observations for the playerItemContext
    guard context == &playerItemContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
          
    if keyPath == #keyPath(AVPlayerItem.status) {
      let status: AVPlayerItem.Status
      if let statusNumber = change?[.newKey] as? NSNumber {
        status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
      } else {
        status = .unknown
      }
      // Switch over status value
      switch status {
        case .readyToPlay:
          addPeriodicTimeObserver()
          player?.play()
        case .failed:
          print(".failed")
        case .unknown:
          print(".unknown")
        @unknown default:
          print("@unknown default")
            }
      }
  }
  
  func play(with url: URL) {
    setUpAsset(with: url) { [weak self] (asset: AVAsset) in
      DispatchQueue.main.async {
        if self?.onLoaded != nil {
          self?.onLoaded!(["durationInSeconds": asset.duration.seconds])
        }
      }
      self?.setUpPlayerItem(with: asset)
    }
  }
  
  @objc
  func pause() {
    DispatchQueue.main.async {
      self.player?.pause()
    }
  }
  
  @objc
  func continueVideo() {
    DispatchQueue.main.async {
      self.player?.play()
    }
  }
  
  @objc
  func seek(to: Double) {
    DispatchQueue.main.async {
      let seekTo = CMTimeMakeWithSeconds(to, preferredTimescale: 1000)
      self.player?.seek(to: seekTo)
    }
  }
  
  deinit {
    playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    removePeriodicTimeObserver()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
