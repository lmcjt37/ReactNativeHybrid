//
//  EventEmitter.swift
//  ReactNavigationSample
//
//  Created by Luke Taylor on 06/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

@objc(EventEmitter)
class EventEmitter: RCTEventEmitter {
  
  override func supportedEvents() -> [String] {
    return ["LogEvent", "LogSuccess"]
  }
  
  override func startObserving() {
    for event in self.supportedEvents() {
      NotificationCenter.default.addObserver(self, selector: #selector(logInternalEvent(notification:)), name:NSNotification.Name(rawValue: event), object: nil)
    }
  }

  override func stopObserving() {
    NotificationCenter.default.removeObserver(self)
  }


  func logInternalEvent(notification: NSNotification) {
    self.sendEvent(withName: notification.name.rawValue, body: notification.userInfo)
  }

  
  @objc func dispatch(name: String, body: Any?) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: self, userInfo: body as! [AnyHashable : Any]?)
  }
  
}
