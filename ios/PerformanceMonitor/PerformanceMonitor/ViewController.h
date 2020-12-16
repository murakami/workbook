//
//  ViewController.h
//  PerformanceMonitor
//
//  Created by 村上幸雄 on 2020/12/15.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)measurement:(id)sender;
@end

