//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Alec O'Connor on 11/26/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme!
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
        memeImageView.image = meme.memedImage
    }
    
    @objc func editMeme() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerID") as! ViewController
        viewController.meme = meme
        present(viewController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
