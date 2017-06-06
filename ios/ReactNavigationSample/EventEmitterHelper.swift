//
//  EventEmitterHelper.swift
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class EventEmitterHelper {

  /// Shared Instance.
  public static var sharedInstance = EventEmitterHelper()
  
  // ReactNativeEventEmitter is instantiated by React Native with the bridge.
  private static var eventEmitter: EventEmitter!
  
  private init() {}
  
  // When React Native instantiates the emitter it is registered here.
  func registerEventEmitter(eventEmitter: EventEmitter) {
    EventEmitterHelper.eventEmitter = eventEmitter
  }
  
  func dispatch(name: String, body: Any?) {
    EventEmitterHelper.eventEmitter.sendEvent(withName: name, body: body)
  }
  
  /// All Events which must be support by React Native.
  lazy var allEvents: [String] = {
    return ["LogEvent", "LogSuccess"]
  }()

}
