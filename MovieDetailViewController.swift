//
//  MovieDetailViewController.swift
//  Rotten Tomatoes
//
//  Created by Bao Nguyen on 8/30/15.
//  Copyright (c) 2015 Bao Nguyen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        
        let url = NSURL(string: movie.valueForKeyPath("posters.detailed") as! String)!
        imageView.setImageWithURL(url)
        
    }
}
