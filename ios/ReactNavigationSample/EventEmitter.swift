//
//  EventEmitter.swift
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

@objc(EventEmitter)
open class EventEmitter: RCTEventEmitter {
  
  override init() {
    super.init()
    EventEmitterHelper.sharedInstance.registerEventEmitter(eventEmitter: self)
  }
  
  @objc open override func supportedEvents() -> [String] {
    return EventEmitterHelper.sharedInstance.allEvents
  }
  
}
