//
//  LRUserInterfaceCustomizationManager.h
//  LinkReaderKit
//
//  Created by Alejandro Mendez on 11/14/17.
//  Copyright © 2017 HP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 The LRUserInterfaceCustomizationManager allows developers to customize user interface elements presented by the LinkReader SDK.
 
 @since 3.1
 */
@interface LRUserInterfaceCustomizationManager : NSObject

/**
 Get a shared instance of the LRUserInterfaceCustomizationManager.
 
 @return The LRUserInterfaceCustomizationManager shared instance
 
 @since 3.1
 */
+ (instancetype)sharedManager;

/**
 The title shown on the top toolbar displayed when the LinkReaderSDK presents an HTML payoff. This will include all Track and Trace payoffs.
 
 @since 3.1
 */
@property (nonatomic) NSString *trackAndTraceWebViewTitle;

@end
