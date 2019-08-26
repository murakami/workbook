//
//  ViewController.swift
//  Tweets
//
//  Created by 村上幸雄 on 2019/08/27.
//  Copyright © 2019 Bitz Co., Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func intentTweet(_ sender : Any) {
        let text = "Web Intentの例"
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let encodedText = encodedText,
            let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func activityTweet(_ sender : Any) {
        let text = "共有機能を利用する"
        let bundlePath = Bundle.main.path(forResource: "brownout", ofType: "jpg")
        let image = UIImage(contentsOfFile: bundlePath!)
        let shareItems = [image, text] as [Any]
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }

}

