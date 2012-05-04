//
//  ConnectionViewController.h
//  PushNotification
//
//  Created by 村上 幸雄 on 12/05/04.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController

@property (strong, nonatomic) NSURLRequest      *urlRequest;
@property (strong, nonatomic) NSURLConnection   *urlConnection;
@property (strong, nonatomic) NSMutableData     *downloadedData;
@property (strong, nonatomic) NSURLResponse     *urlResponse;

- (IBAction)cancel:(id)sender;

@end
