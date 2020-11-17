//
//  LRPayoffBase.h
//  LinkReaderSDK
//
//  Created by Live Paper Pairing on 8/17/17.
//  Copyright © 2017 HP. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This is the base class for different LRPayoff classes
 */
@interface LRPayoffBase : NSObject

@property (nonatomic) NSDictionary *privateData;


- (NSDictionary *)parsePrivateData:(id)payoffObject;

@end
