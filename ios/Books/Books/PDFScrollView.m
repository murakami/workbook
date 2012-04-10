//
//  PDFScrollView.m
//  Books
//
//  Created by 村上 幸雄 on 12/04/10.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "PDFScrollView.h"
#import "TiledPDFView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PDFScrollView

@synthesize pdfView = _pdfView;
@synthesize oldPDFView = _oldPDFView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize pdfScale = _pdfScale;
@synthesize page = _page;
@synthesize pdf = _pdf;

- (id)initWithFrame:(CGRect)frame
{
    DBGMSG(@"%s", __func__);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Set up the UIScrollView
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		[self setBackgroundColor:[UIColor grayColor]];
		self.maximumZoomScale = 5.0;
		self.minimumZoomScale = .25;
		
		// Open the PDF document
		NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"HIDDeviceInterface.pdf" withExtension:nil];
		self.pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
		
		// Get the PDF Page that we will be drawing
		self.page = CGPDFDocumentGetPage(self.pdf, 1);
		CGPDFPageRetain(self.page);
		
		// determine the size of the PDF page
		CGRect pageRect = CGPDFPageGetBoxRect(self.page, kCGPDFMediaBox);
		self.pdfScale = self.frame.size.width/pageRect.size.width;
		pageRect.size = CGSizeMake(pageRect.size.width * self.pdfScale, pageRect.size.height * self.pdfScale);
		
		
		// Create a low res image representation of the PDF page to display before the TiledPDFView
		// renders its content.
		UIGraphicsBeginImageContext(pageRect.size);
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		// First fill the background with white.
		CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
		CGContextFillRect(context,pageRect);
		
		CGContextSaveGState(context);
		// Flip the context so that the PDF page is rendered
		// right side up.
		CGContextTranslateCTM(context, 0.0, pageRect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);
		
		// Scale the context so that the PDF page is rendered 
		// at the correct size for the zoom level.
		CGContextScaleCTM(context, self.pdfScale, self.pdfScale);	
		CGContextDrawPDFPage(context, self.page);
		CGContextRestoreGState(context);
		
		UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
		self.backgroundImageView.frame = pageRect;
		self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.backgroundImageView];
		[self sendSubviewToBack:self.backgroundImageView];
		
		
		// Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
		self.pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:self.pdfScale];
		[self.pdfView setPage:self.page];
		
		[self addSubview:self.pdfView];
    }
    return self;
}

- (void)awakeFromNib
{
    DBGMSG(@"%s", __func__);
    
    // Set up the UIScrollView
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bouncesZoom = YES;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.delegate = self;
    [self setBackgroundColor:[UIColor grayColor]];
    self.maximumZoomScale = 5.0;
    self.minimumZoomScale = .25;
    
    // Open the PDF document
    NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"HIDDeviceInterface.pdf" withExtension:nil];
    self.pdf = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
    
    // Get the PDF Page that we will be drawing
    self.page = CGPDFDocumentGetPage(self.pdf, 1);
    CGPDFPageRetain(self.page);
    
    // determine the size of the PDF page
    CGRect pageRect = CGPDFPageGetBoxRect(self.page, kCGPDFMediaBox);
    self.pdfScale = self.frame.size.width/pageRect.size.width;
    pageRect.size = CGSizeMake(pageRect.size.width * self.pdfScale, pageRect.size.height * self.pdfScale);
    
    
    // Create a low res image representation of the PDF page to display before the TiledPDFView
    // renders its content.
    UIGraphicsBeginImageContext(pageRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // First fill the background with white.
    CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
    CGContextFillRect(context,pageRect);
    
    CGContextSaveGState(context);
    // Flip the context so that the PDF page is rendered
    // right side up.
    CGContextTranslateCTM(context, 0.0, pageRect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Scale the context so that the PDF page is rendered 
    // at the correct size for the zoom level.
    CGContextScaleCTM(context, self.pdfScale, self.pdfScale);	
    CGContextDrawPDFPage(context, self.page);
    CGContextRestoreGState(context);
    
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    self.backgroundImageView.frame = pageRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.backgroundImageView];
    [self sendSubviewToBack:self.backgroundImageView];
    
    
    // Create the TiledPDFView based on the size of the PDF page and scale it to fit the view.
    self.pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:self.pdfScale];
    [self.pdfView setPage:self.page];
    
    [self addSubview:self.pdfView];
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.pdfView = nil;
    self.oldPDFView = nil;
    self.backgroundImageView = nil;
	CGPDFPageRelease(self.page);
	CGPDFDocumentRelease(self.pdf);
	//[super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark Override layoutSubviews to center content

// We use layoutSubviews to center the PDF page in the view
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.pdfView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.pdfView.frame = frameToCenter;
	self.backgroundImageView.frame = frameToCenter;
    
	// to handle the interaction between CATiledLayer and high resolution screens, we need to manually set the
	// tiling view's contentScaleFactor to 1.0. (If we omitted this, it would be 2.0 on high resolution screens,
	// which would cause the CATiledLayer to ask us for tiles of the wrong scales.)
	self.pdfView.contentScaleFactor = 1.0;
}

#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, called when the user starts zooming. 
// We return our current TiledPDFView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pdfView;
}

// A UIScrollView delegate callback, called when the user stops zooming.  When the user stops zooming
// we create a new TiledPDFView based on the new zoom level and draw it on top of the old TiledPDFView.
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	// set the new scale factor for the TiledPDFView
	self.pdfScale *= scale;
	
	// Calculate the new frame for the new TiledPDFView
	CGRect pageRect = CGPDFPageGetBoxRect(self.page, kCGPDFMediaBox);
	pageRect.size = CGSizeMake(pageRect.size.width * self.pdfScale, pageRect.size.height * self.pdfScale);
	
	// Create a new TiledPDFView based on new frame and scaling.
	self.pdfView = [[TiledPDFView alloc] initWithFrame:pageRect andScale:self.pdfScale];
	[self.pdfView setPage:self.page];
	
	// Add the new TiledPDFView to the PDFScrollView.
	[self addSubview:self.pdfView];
}

// A UIScrollView delegate callback, called when the user begins zooming.  When the user begins zooming
// we remove the old TiledPDFView and set the current TiledPDFView to be the old view so we can create a
// a new TiledPDFView when the zooming ends.
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	// Remove back tiled view.
	[self.oldPDFView removeFromSuperview];
	/* [self.oldPDFView release]; */
	
	// Set the current TiledPDFView to be the old view.
	self.oldPDFView = self.pdfView;
	[self addSubview:self.oldPDFView];
}

@end
