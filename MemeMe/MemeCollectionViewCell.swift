//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Alec O'Connor on 11/26/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    var meme: Meme? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func updateCell() {
        let textAttributes = Meme.condensedTextAttributes
        let topString = NSAttributedString(string: meme?.topText ?? "", attributes: textAttributes)
        let bottomString = NSAttributedString(string: meme?.bottomText ?? "", attributes: textAttributes)
        
        topLabel.attributedText = topString
        bottomLabel.attributedText = bottomString
        memeImageView.contentMode = .scaleAspectFit
        memeImageView.image = meme?.originalImage ?? UIImage()
    }
    
}
