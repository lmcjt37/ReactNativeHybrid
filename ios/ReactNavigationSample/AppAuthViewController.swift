//
//  AppAuthViewController.swift
//  ReactNavigationSample
//
//  Created by Luke Taylor on 05/06/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit
import AppAuth

@objc(AppAuthViewController)
class AppAuthViewController: UIViewController, OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate {

  var authState:OIDAuthState?
  
  var constants = Constants()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let rootView = RCTRootView(bridge: appDelegate.bridge, moduleName: "ReactNavigationSample", initialProperties:nil)
    
    rootView?.frame = UIScreen.main.bounds
    
    self.view = UIView()
    
    self.view.addSubview(rootView!)
    
    self.loadState()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  /**
  * React Native methods
  * See for information: AppAuthViewControllerBridge.m
  */
  @objc(authorise:)
  func authorise(callback: RCTResponseSenderBlock) -> Void {
    print("AUTHORISED CALLED")
    self.authWithAutoCodeExchange()
  }
  
  @objc(isAuthorised:)
  func isAuthorised(callback: RCTResponseSenderBlock) -> Void {
    print("IS AUTHORISED CALLED")
    if authState != nil {
      let isAuthorised = authState?.isAuthorized
      callback([isAuthorised!]);
    } else {
      callback([false])
    }
  }
  
  @objc(logout:)
  func logout(callback: RCTResponseSenderBlock) -> Void {
    print("LOGOUT CALLED")
    self.clearState()
  }
  
  func verifyConfig() {
    assert(constants.kIssuer != "https://issuer.example.com","Update kIssuer with your own issuer. Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md")
    
    assert(constants.kClientID != "YOUR_CLIENT_ID","Update kClientID with your own client ID. Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md")
    
    assert(constants.kRedirectURI != "com.example.app:/oauth2redirect/example-provider","Update kRedirectURI with your own redirect URI. Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md")
    
    let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? NSArray
    assert(urlTypes != nil && (urlTypes?.count)! > 0, "No custom URI scheme has been configured for the project.")
    let urlSchemes = (urlTypes!.object(at: 0) as! NSDictionary).object(forKey: "CFBundleURLSchemes") as? NSArray
    assert(urlSchemes != nil && (urlSchemes?.count)! > 0,"No custom URI scheme has been configured for the project.")
    let urlScheme = urlSchemes!.object(at: 0) as? NSString
    
    assert(urlScheme != "com.example.app","Configure the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0) with the scheme of your redirect URI. Full instructions: https://github.com/openid/AppAuth-iOS/blob/master/Example/README.md")
  }
  
  // saves OIDAuthState to NSUSerDefaults
  func saveState(){
    // for production usage consider using the OS Keychain instead
    if authState != nil {
      let archivedAuthState = NSKeyedArchiver.archivedData(withRootObject: authState!)
      UserDefaults.standard.set(archivedAuthState, forKey: constants.kAppAuthAuthStateKey)
    } else {
      UserDefaults.standard.set(nil, forKey: constants.kAppAuthAuthStateKey)
    }
    UserDefaults.standard.synchronize()
  }
  
  // loads OIDAuthState from NSUSerDefaults
  func loadState(){
    guard let archivedAuthState = UserDefaults.standard.object(forKey: constants.kAppAuthAuthStateKey) as? NSData else{
      return
    }
    guard let authState = NSKeyedUnarchiver.unarchiveObject(with: archivedAuthState as Data) as? OIDAuthState else{
      return
    }
    self.setAuthState(authState: authState)
  }
  
  func setAuthState(authState:OIDAuthState?){
    if (self.authState == authState) {
      return
    }
    self.authState = authState
    self.authState?.stateChangeDelegate = self
    self.stateChanged()
  }
  
  func stateChanged(){
    self.saveState()
  }
  
  // when the authorization state changes, storage is updated.
  func didChange(_ state: OIDAuthState) {
    authState = state
    authState?.stateChangeDelegate = self
    self.stateChanged()
  }
  
  func authState(_ state: OIDAuthState, didEncounterAuthorizationError error: Error) {
    self.logMessage(message: "Received authorization error: \(error)")
  }
  
  // Authorisation code flow with auto code exchanges
  func authWithAutoCodeExchange() {
    self.verifyConfig()
    
    let issuer = NSURL(string: constants.kIssuer)
    let redirectURI = NSURL(string: constants.kRedirectURI)
    
    self.logMessage(message: "Fetching configuration for issuer: \(issuer!)")
    
    // discovers endpoints
    OIDAuthorizationService.discoverConfiguration(forIssuer: issuer! as URL){
      configuration,error in
      
      if configuration == nil {
        self.logMessage(message: "Error retrieving discovery document: \(error?.localizedDescription)")
        self.clearState()
        return
      }
      
      self.logMessage(message: "Got configuration: \(configuration!)")
      
      // builds authentication request
      let request = OIDAuthorizationRequest(configuration: configuration!, clientId: self.constants.kClientID, scopes: [OIDScopeOpenID, OIDScopeProfile], redirectURL: redirectURI! as URL, responseType: OIDResponseTypeCode, additionalParameters: nil)
      
      // performs authentication request
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      self.logMessage(message: "Initiating authorization request with scope: \(request.scope!)")
      
      appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: (appDelegate.window?.rootViewController)!){
        authState,error in
        if authState != nil{
          self.setAuthState(authState: authState)
          self.logMessage(message: "Got authorization tokens. Access token: \(authState!.lastTokenResponse!.accessToken!)")
          self.userinfo()
        }
        else{
          self.logMessage(message: "Authorization error: \(error!.localizedDescription)")
          self.clearState()
        }
      }
    }
  }
  
  // Performs a Userinfo API call using @c OIDAuthState.withFreshTokensPerformAction.
  func userinfo() {
    let userInfoEndpoint = authState?.lastAuthorizationResponse.request.configuration.discoveryDocument?.userinfoEndpoint
    if userInfoEndpoint == nil{
      self.logMessage(message: "Userinfo endpoint not declared in discovery document")
      return
    }
    let currentAccessToken = authState?.lastTokenResponse?.accessToken
    
    self.logMessage(message: "Performing userinfo request")
    
    authState?.performAction(){
      accessToken,idToken,error in
      if error != nil{
        self.logMessage(message: "Error fetching fresh tokens: \(error!.localizedDescription)")
        return
      }
      
      // log whether a token refresh occurred
      if currentAccessToken != accessToken{
        self.logMessage(message: "Access token was refreshed automatically (\(currentAccessToken!) to \(accessToken!)")
      }
      else{
        self.logMessage(message: "Access token was fresh and not updated [\(accessToken!)]")
      }
      
      // creates request to the userinfo endpoint, with access token in the Authorization header
      let request = NSMutableURLRequest(url: userInfoEndpoint!)
      let authorizationHeaderValue = "Bearer \(accessToken!)"
      request.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
      
      let configuration = URLSessionConfiguration.default
      let session = URLSession(configuration: configuration)
      
      // performs HTTP request
      let postDataTask = session.dataTask(with: request as URLRequest){
        data,response,error in
        DispatchQueue.main.async {
          guard let httpResponse = response as? HTTPURLResponse else{
            self.logMessage(message: "Non-HTTP response \(error)")
            return
          }
          do{
            let jsonDictionaryOrArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            if httpResponse.statusCode != 200{
              let responseText = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
              if httpResponse.statusCode == 401{
                // "401 Unauthorized" generally indicates there is an issue with the authorization
                // grant. Puts OIDAuthState into an error state.
                let oauthError = OIDErrorUtilities.resourceServerAuthorizationError(withCode: 0, errorResponse: jsonDictionaryOrArray as? [NSObject : AnyObject], underlyingError: error)
                self.authState?.update(withAuthorizationError: oauthError)
                //log error
                self.logMessage(message: "Authorization Error (\(oauthError)). Response: \(responseText)")
              }
              else{
                self.logMessage(message: "HTTP: \(httpResponse.statusCode). Response: \(responseText)")
              }
              return
            }
//            self.logMessage(message: "Success: \(jsonDictionaryOrArray)")
            EventEmitterHelper.sharedInstance.dispatch(name: "LogSuccess", body: jsonDictionaryOrArray)
          }
          catch{
            self.logMessage(message: "Error while serializing data to JSON")
          }
        }
      }
      postDataTask.resume()
    }
  }
  
  func clearState() {
    self.setAuthState(authState: nil)
    self.logMessage(message: "Auth state has been cleared")
  }
  
  func logMessage(message:String){
    // outputs to stdout
    print(message)
    
    EventEmitterHelper.sharedInstance.dispatch(name: "LogEvent", body: message)
  }
}
