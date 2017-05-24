/*! @file AppAuthExampleViewController.m
    @brief AppAuth iOS SDK Example
    @copyright
        Copyright 2015 Google Inc. All Rights Reserved.
    @copydetails
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.
 */

#import "AppAuthExampleViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "AppAuth.h"
#import "AppDelegate.h"
#import "Constants.h"

typedef void (^PostRegistrationCallback)(OIDServiceConfiguration *configuration,
                                         OIDRegistrationResponse *registrationResponse);

/*! @brief Replaced with a constants file - LT
 */

/*! @brief The OIDC issuer from which the configuration will be discovered.
 */
//static NSString *const kIssuer = @"<YOUR_ISSUER_HERE>";

/*! @brief The OAuth client ID.
    @discussion For client configuration instructions, see the README.
        Set to nil to use dynamic registration with this example.
    @see https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md
 */
//static NSString *const kClientID = @"<YOUR_CLIENT_ID_HERE>";

/*! @brief The OAuth redirect URI for the client @c kClientID.
    @discussion For client configuration instructions, see the README.
    @see https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md
 */
//static NSString *const kRedirectURI = @"<YOUR_REDIRECT_URL_HERE>";

/*! @brief NSCoding key for the authState property.
 */
//static NSString *const kAppAuthExampleAuthStateKey = @"AuthState";

@interface AppAuthExampleViewController () <OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate>
@end

@implementation AppAuthExampleViewController

RCT_EXPORT_MODULE(CustomAppAuth);

RCT_EXPORT_METHOD(authorise:(RCTResponseSenderBlock)callback) {

  [self authWithAutoCodeExchange];
  
  callback(@[[NSNull null], @"authorise was fired..."]);

}

RCT_EXPORT_METHOD(signin:(RCTResponseSenderBlock)callback) {

  NSLog(@"signin was fired...");

  [self userinfo];
  
  callback(@[[NSNull null], @""]);

}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self loadState];
  [self updateUI];
}

- (void)verifyConfig {
#if !defined(NS_BLOCK_ASSERTIONS)

  // The example needs to be configured with your own client details.
  // See: https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md

  NSAssert(![K_ISSUER isEqualToString:@"https://issuer.example.com"],
           @"Update kIssuer with your own issuer. "
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md");

  NSAssert(![K_CLIENT_ID isEqualToString:@"YOUR_CLIENT_ID"],
           @"Update kClientID with your own client ID. "
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md");

  NSAssert(![K_REDIRECT_URI isEqualToString:@"com.example.app:/oauth2redirect/example-provider"],
           @"Update kRedirectURI with your own redirect URI. "
            "Instructions: https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md");

  // verifies that the custom URI scheme has been updated in the Info.plist
  NSArray __unused* urlTypes =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
  NSAssert([urlTypes count] > 0, @"No custom URI scheme has been configured for the project.");
  NSArray *urlSchemes =
      [(NSDictionary *)[urlTypes objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"];
  NSAssert([urlSchemes count] > 0, @"No custom URI scheme has been configured for the project.");
  NSString *urlScheme = [urlSchemes objectAtIndex:0];

  NSAssert(![urlScheme isEqualToString:@"com.example.app"],
           @"Configure the URI scheme in Info.plist (URL Types -> Item 0 -> URL Schemes -> Item 0) "
            "with the scheme of your redirect URI. Full instructions: "
            "https://github.com/openid/AppAuth-iOS/blob/master/Examples/Example-iOS_ObjC/README.md");

#endif // !defined(NS_BLOCK_ASSERTIONS)
}

/*! @brief Saves the @c OIDAuthState to @c NSUSerDefaults.
 */
- (void)saveState {
  // for production usage consider using the OS Keychain instead
  NSData *archivedAuthState = [ NSKeyedArchiver archivedDataWithRootObject:_authState];
  [[NSUserDefaults standardUserDefaults] setObject:archivedAuthState
                                            forKey:K_APPAUTH_AUTH_STATE_KEY];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

/*! @brief Loads the @c OIDAuthState from @c NSUSerDefaults.
 */
- (void)loadState {
  // loads OIDAuthState from NSUSerDefaults
  NSData *archivedAuthState =
      [[NSUserDefaults standardUserDefaults] objectForKey:K_APPAUTH_AUTH_STATE_KEY];
  OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
  [self setAuthState:authState];
}

- (void)setAuthState:(nullable OIDAuthState *)authState {
  if (_authState == authState) {
    return;
  }
  _authState = authState;
  _authState.stateChangeDelegate = self;
  [self stateChanged];
}

/*! @brief Refreshes UI, typically called after the auth state changed.
 */
- (void)updateUI {

  /*! LT - updates to UI should be handled by React-Native
   */
  NSLog(@"Update UI called");

}

- (void)stateChanged {
  [self saveState];
  [self updateUI];
}

- (void)didChangeState:(OIDAuthState *)state {
  [self stateChanged];
}

- (void)authState:(OIDAuthState *)state didEncounterAuthorizationError:(nonnull NSError *)error {
  [self logMessage:@"Received authorization error: %@", error];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)doClientRegistration:(OIDServiceConfiguration *)configuration
                    callback:(PostRegistrationCallback)callback {
    NSURL *redirectURI = [NSURL URLWithString:K_REDIRECT_URI];
  
    OIDRegistrationRequest *request =
        [[OIDRegistrationRequest alloc] initWithConfiguration:configuration
                                                 redirectURIs:@[ redirectURI ]
                                                responseTypes:nil
                                                   grantTypes:nil
                                                  subjectType:nil
                                      tokenEndpointAuthMethod:@"client_secret_post"
                                         additionalParameters:nil];
    // performs registration request
    [self logMessage:@"Initiating registration request"];

    [OIDAuthorizationService performRegistrationRequest:request
        completion:^(OIDRegistrationResponse *_Nullable regResp, NSError *_Nullable error) {
      if (regResp) {
        [self setAuthState:[[OIDAuthState alloc] initWithRegistrationResponse:regResp]];
        [self logMessage:@"Got registration response: [%@]", regResp];
        callback(configuration, regResp);
      } else {
        [self logMessage:@"Registration error: %@", [error localizedDescription]];
        [self setAuthState:nil];
      }
    }];
}

- (void)doAuthWithAutoCodeExchange:(OIDServiceConfiguration *)configuration
                          clientID:(NSString *)clientID
                      clientSecret:(NSString *)clientSecret {
  NSURL *redirectURI = [NSURL URLWithString:K_REDIRECT_URI];
  
  // builds authentication request
  OIDAuthorizationRequest *request =
      [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                    clientId:clientID
                                                clientSecret:clientSecret
                                                      scopes:@[ OIDScopeOpenID, OIDScopeProfile ]
                                                 redirectURL:redirectURI
                                                responseType:OIDResponseTypeCode
                                        additionalParameters:nil];
  // performs authentication request
  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  [self logMessage:@"Initiating authorization request with scope: %@", request.scope];
  
  // LT - set presentingViewController to be rootController(React rootView)
  appDelegate.currentAuthorizationFlow =
      [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                     presentingViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
                                                     callback:^(OIDAuthState *_Nullable authState, NSError *_Nullable error) {
                                                       NSLog(@"---->> %@", authState);
            if (authState) {
              [self setAuthState:authState];
              [self logMessage:@"Got authorization tokens. Access token: %@",
                               authState.lastTokenResponse.accessToken];
            } else {
              [self logMessage:@"Authorization error: %@", [error localizedDescription]];
              [self setAuthState:nil];
            }
          }];
}

- (void)authWithAutoCodeExchange {
  [self verifyConfig];

  NSURL *issuer = [NSURL URLWithString:K_ISSUER];

  [self logMessage:@"Fetching configuration for issuer: %@", issuer];

  // discovers endpoints
  [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
      completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
    if (!configuration) {
      [self logMessage:@"Error retrieving discovery document: %@", [error localizedDescription]];
      [self setAuthState:nil];
      return;
    }

    [self logMessage:@"Got configuration: %@", configuration];

    if (!K_CLIENT_ID) {
      [self doClientRegistration:configuration
                        callback:^(OIDServiceConfiguration *configuration,
                                   OIDRegistrationResponse *registrationResponse) {
        [self doAuthWithAutoCodeExchange:configuration
                                clientID:registrationResponse.clientID
                            clientSecret:registrationResponse.clientSecret];
      }];
    } else {
      [self doAuthWithAutoCodeExchange:configuration clientID:K_CLIENT_ID clientSecret:nil];
    }
   }];
}

- (void)userinfo {
  NSURL *userinfoEndpoint =
      _authState.lastAuthorizationResponse.request.configuration.discoveryDocument.userinfoEndpoint;
  if (!userinfoEndpoint) {
    [self logMessage:@"Userinfo endpoint not declared in discovery document"];
    return;
  }
  NSString *currentAccessToken = _authState.lastTokenResponse.accessToken;

  [self logMessage:@"Performing userinfo request"];

  [_authState performActionWithFreshTokens:^(NSString *_Nonnull accessToken,
                                             NSString *_Nonnull idToken,
                                             NSError *_Nullable error) {
    if (error) {
      [self logMessage:@"Error fetching fresh tokens: %@", [error localizedDescription]];
      return;
    }

    // log whether a token refresh occurred
    if (![currentAccessToken isEqual:accessToken]) {
      [self logMessage:@"Access token was refreshed automatically (%@ to %@)",
                         currentAccessToken,
                         accessToken];
    } else {
      [self logMessage:@"Access token was fresh and not updated [%@]", accessToken];
    }

    // creates request to the userinfo endpoint, with access token in the Authorization header
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:userinfoEndpoint];
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", accessToken];
    [request addValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];

    NSURLSessionConfiguration *configuration =
        [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:nil
                                                     delegateQueue:nil];

    // performs HTTP request
    NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData *_Nullable data,
                                       NSURLResponse *_Nullable response,
                                       NSError *_Nullable error) {
      dispatch_async(dispatch_get_main_queue(), ^() {
        if (error) {
          [self logMessage:@"HTTP request failed %@", error];
          return;
        }
        if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
          [self logMessage:@"Non-HTTP response"];
          return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        id jsonDictionaryOrArray =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

        if (httpResponse.statusCode != 200) {
          // server replied with an error
          NSString *responseText = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
          if (httpResponse.statusCode == 401) {
            // "401 Unauthorized" generally indicates there is an issue with the authorization
            // grant. Puts OIDAuthState into an error state.
            NSError *oauthError =
                [OIDErrorUtilities resourceServerAuthorizationErrorWithCode:0
                                                              errorResponse:jsonDictionaryOrArray
                                                            underlyingError:error];
            [_authState updateWithAuthorizationError:oauthError];
            // log error
            [self logMessage:@"Authorization Error (%@). Response: %@", oauthError, responseText];
          } else {
            [self logMessage:@"HTTP: %d. Response: %@",
                             (int)httpResponse.statusCode,
                             responseText];
          }
          return;
        }

        // success response
        [self logMessage:@"Success: %@", jsonDictionaryOrArray];
      });
    }];

    [postDataTask resume];
  }];
}

/*! @brief Logs a message to stdout and the textfield.
    @param format The format string and arguments.
 */
- (void)logMessage:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2) {
  // gets message as string
  va_list argp;
  va_start(argp, format);
  NSString *log = [[NSString alloc] initWithFormat:format arguments:argp];
  va_end(argp);

  // outputs to stdout
  NSLog(@"%@", log);

  // appends to output log
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"hh:mm:ss";
  
  /* LT - May be used at some point in the future
   */
  
//  NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//  _logTextView.text = [NSString stringWithFormat:@"%@%@%@: %@",
//                                                 _logTextView.text,
//                                                 ([_logTextView.text length] > 0) ? @"\n" : @"",
//                                                 dateString,
//                                                 log];
}

@end
