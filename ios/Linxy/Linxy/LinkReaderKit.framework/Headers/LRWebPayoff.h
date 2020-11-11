//
//  HPWebPayoff.h
//  LinkReaderSDK
//
//  Copyright (c) 2015 HP. All rights reserved.
//

#import <LinkReaderKit/LRPayoff.h>
#import <LinkReaderKit/LRPayoffBase.h>

/**
 Describes a web payoff available via URL (eg, a website)
 
 @since 1.0
 */
@interface LRWebPayoff : LRPayoffBase <LRPayoff>

/**
 The URL to the website
 
 @since 1.0
 */
@property NSString * url;

/**
 Create an LRWebPayoff with a given URL

 @param url destination URL

 @return instance of LRWebPayoff
 
 @since 1.0
 */
- (instancetype)initWithUrl:(NSString *)url;

/**
 Indicates if the web payoff's trigger was not created with the Link technology
 
 @since 1.0
 */
- (BOOL)isExternal;

/**
 Show Web Preview
 
 @since 1.1
 */
- (void)showWebPreview:(BOOL)value;

@end
