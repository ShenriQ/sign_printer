//
//  LRHtmlPayoff.h
//  LinkReaderSDK
//
//  Created by Live Paper Pairing on 8/17/17.
//  Copyright © 2017 HP. All rights reserved.
//

#import <LinkReaderKit/LRPayoff.h>
#import <LinkReaderKit/LRPayoffBase.h>

/**
 Describes an HTML payoff, which contains an HTML string. When the payoff is presented, the HTML will be displayed in a webview.
 
 @since 3.1
 */
@interface LRHtmlPayoff : LRPayoffBase <LRPayoff>

/**
 The HTML string to be loaded on a browser
 
 @since 3.1
 */
@property (nonatomic) NSString *htmlString;

/**
 The base URL for the content to be loaded in the browser
 
 @since 3.1
 */
@property (nonatomic) NSURL *hostUrl;

@end
