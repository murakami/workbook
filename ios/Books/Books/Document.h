//
//  Document.h
//  Books
//
//  Created by 村上 幸雄 on 12/04/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Document : NSObject

@property (strong, nonatomic) NSString  *version;
@property (nonatomic, assign) CGPDFDocumentRef  pdf;

- (void)clearDefaults;
- (void)updateDefaults;
- (void)loadDefaults;
@end
