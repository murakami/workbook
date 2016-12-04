//
//  CardCell.swift
//  Hand
//
//  Created by 村上幸雄 on 2016/11/25.
//  Copyright © 2016年 Bitz Co., Ltd. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func fillWith(card: Card) {
        titleLabel?.text = card.title
    }

}
