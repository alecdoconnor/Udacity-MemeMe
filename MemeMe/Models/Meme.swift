//
//  Meme.swift
//  MemeMe
//
//  Created by Alec O'Connor on 11/26/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

struct Meme {
    
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    static let textAttributes: [String:Any] = [
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.strokeWidth.rawValue: -2.0]
    
}
