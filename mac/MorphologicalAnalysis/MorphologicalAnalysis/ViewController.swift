//
//  ViewController.swift
//  MorphologicalAnalysis
//
//  Created by 村上幸雄 on 2019/04/14.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        analyzeNaturalLanguageText()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func analyzeNaturalLanguageText() {
        let text = "東京は、哀しい活気を呈していた、とさいしょの書き出しの一行に書きしるすというような事になるのではあるまいか、と思って東京に舞い戻って来たのに、私の眼には、何の事も無い相変らずの「東京生活」のごとくに映った。"
        let linguisticTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "ja"), options: 0)
        linguisticTagger.string = text
        linguisticTagger.enumerateTags(in: NSRange(location: 0, length: text.count),
                             scheme: NSLinguisticTagScheme.tokenType,
                             options: [.omitWhitespace]) {
                                tag, tokenRange, sentenceRange, stop in
                                let subString = (text as NSString).substring(with: tokenRange)
                                print("\(subString) : \(String(describing: tag))")
        }
    }
}

