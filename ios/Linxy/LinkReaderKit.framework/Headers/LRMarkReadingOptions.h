//
//  LRMarkReadingOptions.h
//  LinkReaderSDK
//
//  Created by Alejandro Mendez on 1/10/18.
//  Copyright © 2018 HP. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, LRMarkReadingOptions){
    LRMarkReadingWatermark = 1 << 0,
    LRMarkReadingQRCode    = 1 << 1
};
