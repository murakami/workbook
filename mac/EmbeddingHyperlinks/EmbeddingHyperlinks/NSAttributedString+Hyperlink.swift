//
//  NSAttributedString+Hyperlink.swift
//  EmbeddingHyperlinks
//
//  Created by 村上幸雄 on 2022/09/01.
//

import Cocoa

extension NSAttributedString {
    class func hyperlink(inString: String, aURL: NSURL) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: inString)
        let range = NSMakeRange(0, attrString.length)
        
        attrString.beginEditing()
        attrString.addAttribute(.link, value: aURL.absoluteString ?? "", range: range)
        
        /* make the text appear in blue */
        attrString.addAttribute(.foregroundColor, value: NSColor.blue, range:range)
        
        /* next make the text appear with an underline */
        attrString.addAttribute(.underlineStyle, value:NSNumber(value: NSUnderlineStyle.single.rawValue), range:range)
        
        attrString.endEditing()
        
        return attrString
    }
}
