//
//  Constants.swift
//  ReactNavigationSample
//
//  Created by Luke Taylor on 05/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

class Constants {
  let kIssuer: String!
  let kClientID: String!
  let kRedirectURI: String!
  let kAppAuthAuthStateKey: String!
  
  init(){
    kIssuer = "https://first-utility.eu.auth0.com"
    kClientID = "vJKSSB4k5Ir5Wo3SnHb4KiwA4IEu5NIg"
    kRedirectURI = "com.firstutility.reactnavigationsample://first-utility.eu.auth0.com/ios/com.firstutility.reactnavigationsample/callback"
    kAppAuthAuthStateKey = "AuthState"
  }
}
