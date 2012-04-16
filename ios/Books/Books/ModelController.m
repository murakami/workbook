//
//  ModelController.m
//  Books
//
//  Created by 村上 幸雄 on 12/04/07.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import "AppDelegate.h"
#import "ModelController.h"
#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
/* @property (readonly, strong, nonatomic) NSArray *pageData; */
@end

@implementation ModelController

/* @synthesize pageData = _pageData; */
@synthesize document = _document;

- (id)init
{
    DBGMSG(@"%s", __func__);
    self = [super init];
    if (self) {
        // Create the data model.
        /*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
        */
        
        AppDelegate	*appl = nil;
        appl = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.document = appl.document;
    }
    return self;
}

- (void)dealloc
{
    DBGMSG(@"%s", __func__);
    self.document = nil;
	//[super dealloc];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    DBGMSG(@"%s", __func__);
    // Return the data view controller for the given index.
    /*
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    */
    if ((CGPDFDocumentGetNumberOfPages(self.document.pdf) == 0)
        || (index >= CGPDFDocumentGetNumberOfPages(self.document.pdf))) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    /* dataViewController.dataObject = [self.pageData objectAtIndex:index]; */
    [dataViewController setIndexOfPDF:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    /* return [self.pageData indexOfObject:viewController.dataObject]; */
    return viewController.index;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    /*
    if (index == [self.pageData count]) {
        return nil;
    }
    */
    if (index == CGPDFDocumentGetNumberOfPages(self.document.pdf)) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
