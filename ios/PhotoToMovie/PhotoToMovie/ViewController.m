//
//  ViewController.m
//  PhotoToMovie
//
//  Created by 村上幸雄 on 2014/08/12.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (strong, nonatomic) AVAssetWriter *movieAssetWriter;
@property (readonly) NSArray                *images;
@property (readonly) CGSize                 imageSize;
@property (readonly) NSString               *moviePath;
- (void)_photoToMovie;
- (CVPixelBufferRef)_pixelBufferFromCGImage:(CGImageRef)image;
- (void)_removeMovieFile;
- (void)_saveMovie;
- (void)_completionHandlerWithVideo:(NSString *)videoPath
           didFinishSavingWithError:(NSError *)error
                        contextInfo:(void *)contextInfo;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photoToMovie:(id)sender
{
    [self _photoToMovie];
}

- (NSArray *)images
{
    return @[[UIImage imageNamed:@"one"],
             [UIImage imageNamed:@"two"],
             [UIImage imageNamed:@"three"],
             [UIImage imageNamed:@"four"]];
}

-(CGSize)imageSize
{
    /* 全画像のサイズが同一を想定している */
    return ((UIImage *)self.images[0]).size;
}

- (NSString *)moviePath
{
    /* 出力ファイルのパスを作成 */
    NSArray     *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString    *documentPath = paths[0];
    NSString    *moviePath = [documentPath stringByAppendingPathComponent:@"photo2movie.mov"];
    DBGMSG(@"%s moviePath(%@)", __func__, moviePath);
    return moviePath;
}

- (void)_photoToMovie
{
    /* 既存の動画ファイルを削除 */
    [self _removeMovieFile];
    
    /* 動画出力インスタンスを生成 */
    NSError *error = nil;
    self.movieAssetWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.moviePath]
                                                             fileType:AVFileTypeQuickTimeMovie
                                                                error:&error];
    if (error) {
        DBGMSG(@"%@", [error localizedDescription]);
        return;
    }
    
    /* AVAssetWriterInputはCMSampleBufferRefでデータを受け取る */
    AVAssetWriterInput  *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                               outputSettings:@{AVVideoCodecKey:AVVideoCodecH264,
                                                                                                AVVideoWidthKey:@(self.imageSize.width),
                                                                                                AVVideoHeightKey:@(self.imageSize.height)}];
    [self.movieAssetWriter addInput:assetWriterInput];
    
    /* AVAssetWriterInputPixelBufferAdaptorを使うとCVPixelBufferRefでデータを受け取れる */
    AVAssetWriterInputPixelBufferAdaptor    *assetWriterInputPixelBufferAdaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterInput
                                                                                                                                                   sourcePixelBufferAttributes:@{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_32ARGB),
                                                                                                                                                                                 (NSString *)kCVPixelBufferWidthKey:@(self.imageSize.width),
                                                                                                                                                                                 (NSString *)kCVPixelBufferHeightKey:@(self.imageSize.height)}];
    
    assetWriterInput.expectsMediaDataInRealTime = YES;
    
    /* 動画生成開始 */
    if (![self.movieAssetWriter startWriting]) {
        DBGMSG(@"Failed to start writing.");
        return;
    }
    
    [self.movieAssetWriter startSessionAtSourceTime:kCMTimeZero];
    
    int frameCount = 0;
    int durationForEachImage = 1;
    int32_t fps = 24;
    
    for (UIImage *image in self.images) {
        if (assetWriterInputPixelBufferAdaptor.assetWriterInput.readyForMoreMediaData) {
            CMTime frameTime = CMTimeMake((int64_t)frameCount * fps * durationForEachImage, fps);
            
            CVPixelBufferRef    pixelBufferRef = [self _pixelBufferFromCGImage:image.CGImage];
            
            if (![assetWriterInputPixelBufferAdaptor appendPixelBuffer:pixelBufferRef withPresentationTime:frameTime]) {
                DBGMSG(@"Failed to append buffer. [image : %@]", image);
            }
            
            if(pixelBufferRef) {
                CVBufferRelease(pixelBufferRef);
            }
            
            frameCount++;
        }
    }
    
    // 動画生成終了
    [assetWriterInput markAsFinished];
    [self _saveMovie];
    CVPixelBufferPoolRelease(assetWriterInputPixelBufferAdaptor.pixelBufferPool);
}

- (CVPixelBufferRef)_pixelBufferFromCGImage:(CGImageRef)imageRef
{
    NSDictionary *options = @{(NSString *)kCVPixelBufferCGImageCompatibilityKey:@(YES),
                              (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey:@(YES)};

    CVPixelBufferRef pxbuffer = NULL;

    CVPixelBufferCreate(kCFAllocatorDefault,
                        CGImageGetWidth(imageRef),
                        CGImageGetHeight(imageRef),
                        kCVPixelFormatType_32ARGB,
                        (__bridge CFDictionaryRef)options,
                        &pxbuffer);

    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 4 * CGImageGetWidth(imageRef),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);

    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void)_removeMovieFile
{
    /* 既存の動画ファイルを削除 */
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.moviePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.moviePath error:&error];
        if (error) {
            DBGMSG(@"%@", [error localizedDescription]);
        }
    }
}

- (void)_saveMovie
{
    /* 書き込み */
    [self.movieAssetWriter finishWritingWithCompletionHandler:^{
        DBGMSG(@"Finish writing!");
        self.movieAssetWriter = nil;
        
        UISaveVideoAtPathToSavedPhotosAlbum(self.moviePath, self, @selector(_completionHandlerWithVideo:didFinishSavingWithError:contextInfo:), NULL);
    }];
}

- (void)_completionHandlerWithVideo:(NSString *)videoPath
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo
{
    DBGMSG(@"%s error:%@", __func__, error);
}

@end
