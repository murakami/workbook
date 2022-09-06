//
//  ViewController.swift
//  EmbeddingHyperlinks
//
//  Created by 村上幸雄 on 2022/09/01.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate, NSTextViewDelegate {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var textView: NSTextView!

    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textField.delegate = self
        textView.delegate = self
        
        setHyperlink(inTextField: textField)
        setHyperlink(inTextView: textView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    internal func controlTextDidChange(_ obj: Notification) {
        print(#function)
        if let textField = obj.object as? NSTextField {
            //setHyperlink(inTextField: textField)
        }
    }
    
    internal func textDidChange(_ notification: Notification) {
        print(#function)
        if let textView = notification.object as? NSTextView {
            //setHyperlink(inTextView: textView)
        }
    }
    
    private func setHyperlink(inTextField: NSTextField) {
        // both are needed, otherwise hyperlink won't accept mousedown
        inTextField.allowsEditingTextAttributes = true
        inTextField.isSelectable = true
        
        if let url = NSURL(string: "http://www.bitz.co.jp/") {
            let string = NSMutableAttributedString()
            string.append(NSAttributedString.hyperlink(inString: "Bitz Co., Ltd.", aURL: url))
            
            // set the attributed string to the NSTextField
            inTextField.attributedStringValue = string
        }
    }
    
    private func setHyperlink(inTextView: NSTextView) {
        // create the attributed string
        let string = NSMutableAttributedString()
        
            // create the url and use it for our attributed string
        if let url = NSURL(string: "http://www.bitz.co.jp/") {
            string.append(NSAttributedString.hyperlink(inString: "Bitz Co., Ltd.", aURL: url))
            
            // apply it to the NSTextView's text storage
            inTextView.textStorage?.setAttributedString(string)
        }
    }

}

