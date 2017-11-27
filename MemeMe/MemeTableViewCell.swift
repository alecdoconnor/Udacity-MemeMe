//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Alec O'Connor on 11/26/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    var meme: Meme? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topGeneralLabel: UILabel!
    @IBOutlet weak var bottomGeneralLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell() {
        let textAttributes = Meme.condensedTextAttributes
        let topString = NSAttributedString(string: meme?.topText ?? "", attributes: textAttributes)
        let bottomString = NSAttributedString(string: meme?.bottomText ?? "", attributes: textAttributes)
        
        topLabel.attributedText = topString
        bottomLabel.attributedText = bottomString
        topGeneralLabel.text = meme?.topText ?? ""
        bottomGeneralLabel.text = meme?.bottomText ?? ""
        memeImageView.image = meme?.originalImage ?? UIImage()
    }

}
