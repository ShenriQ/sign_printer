//
//  LRCustomDataPayoff.h
//  LinkReaderSDK
//
//  Created by Live Paper Pairing on 7/6/17.
//  Copyright © 2017 HP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LinkReaderKit/LRPayoff.h>
#import <LinkReaderKit/LRPayoffBase.h>

/**
 A custom data payoff can be associated with any user defined data
 
 @since 2.2.0
 */
@interface LRCustomDataPayoff : LRPayoffBase <LRPayoff>


/**
 The custom data associated to the payoff
 
 @since 2.2.0
 */
@property (nonatomic) NSDictionary *customData;

/**
 The public URL for the payoff
 
 @since 2.2.0
 */
@property (nonatomic) NSURL *publicUrl;

/**
 The version for the payoff
 
 @since 2.2.0
 */
@property (nonatomic) NSString *version;

@end
