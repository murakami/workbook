//
//  Document.h
//  Wibree
//
//  Created by 村上幸雄 on 2014/02/10.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WIBREE_SERVICE_UUID         @"EAD5D6C9-BFCF-44EE-91D4-45C2501456E2"
#define WIBREE_CHARACTERISTIC_UUID  @"22AD9740-FBED-44E8-9B7B-5F9A12974D2F"
#define BEACON_SERVICE_UUID         @"0AE4A21D-6096-4D71-8831-56A6FC7ACAB9"

@interface Document : NSObject

@property (strong, nonatomic) NSString              *version;
@property (strong, readonly, nonatomic) NSString    *uniqueIdentifier;

+ (Document *)sharedDocument;
- (void)load;
- (void)save;

@end
