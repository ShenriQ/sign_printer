//
//  ARPayoff.h
//  LinkReaderKit
//
//  Created by Nomad on 2/8/18.
//  Copyright © 2018 HP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LinkReaderKit/LRPayoff.h>
#import <LinkReaderKit/LRPayoffBase.h>

/**
 An Automated Reality (AR) payoff
 
 @since 3.2.0
 */
@interface ARPayoff : LRPayoffBase <LRPayoff>

/**
 The AR data associated with the payoff
 
 @since 3.2.0
 */
@property (nonatomic) NSDictionary *arData;

/**
 The version for the AR payoff
 
 @since 3.2.0
 */
@property (nonatomic) NSString *version;

/**
 The aura ID associated with the AR payoff
 
 @since 3.2.0
 */
@property (nonatomic) NSString *auraId;

/**
 The public URL associated with the AR payoff
 
 @since 3.2.0
 */
@property (nonatomic) NSURL *publicUrl;

@end
