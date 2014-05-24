//
//  AppDelegate.m
//  Ruby
//
//  Created by 村上幸雄 on 2014/05/24.
//  Copyright (c) 2014年 村上幸雄. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    DBGMSG(@"%s", __func__);
}

- (IBAction)doRuby:(id)sender
{
    DBGMSG(@"%s", __func__);
    
    NSString *inputText = self.inputTextField.stringValue;
    DBGMSG(@"%s input:%@", __func__, inputText);
    
    NSMutableString *outputText = [[NSMutableString alloc] init];
    
    CFRange range = CFRangeMake(0, [inputText length]);
    CFLocaleRef locale = CFLocaleCopyCurrent();
    
    /* トークナイザーを作成 */
    CFStringTokenizerRef    tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                                (CFStringRef)inputText,
                                                                range,
                                                                kCFStringTokenizerUnitWordBoundary,
                                                                locale);
    
    /* 最初の位置に */
    CFStringTokenizerTokenType  tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0);
    
    /* 形態素解析 */
    while (tokenType != kCFStringTokenizerTokenNone) {
        range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
        
        /* ローマ字を得る */
        CFTypeRef   latin = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer,
                                                                       kCFStringTokenizerAttributeLatinTranscription);
        NSString    *romaji = (__bridge NSString *)latin;
        
        NSString    *token = [inputText substringWithRange:NSMakeRange(range.location, range.length)];
        
        /* 平仮名に変換 */
        NSMutableString *furigana = [romaji mutableCopy];
        CFStringTransform((CFMutableStringRef)furigana, NULL, kCFStringTransformLatinHiragana, false);
        
        [outputText appendString:furigana];
        DBGMSG(@"%s token(%@) latin(%@) furigana(%@)" ,__func__, token, latin, furigana);
        
        CFRelease(latin);
        tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
    }
    CFRelease(tokenizer);
    
    CFRelease(locale);
    
    [self.outputLabel setStringValue:outputText];
}

@end
