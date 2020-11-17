//
//  LRUID.h
//  LinkReaderKit
//
//  Created by Alejandro Mendez on 1/12/18.
//  Copyright © 2018 HP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LinkReaderKit/LRDetection.h>

@interface LRUID : NSObject

@property (nonatomic, readonly) NSString *value;
@property (nonatomic, readonly) LRTriggerType type;

@end
