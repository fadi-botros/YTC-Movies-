//
//  MovieDetailsViewController.swift
//  YTC Mobile Client
//
//  Created by apple on 12/18/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    //Mark: Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UITextView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //Mark: Variables
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set my segues data to current viewController
        //Includes backgroundImage, name, describtiontext and date.
        
        backgroundImage.kf.setImage(with: URL(string: (movie!.imgUrl)))
        movieNameLabel.text = movie?.name
        descriptionTextView.text = movie?.descriptionText
        dateLabel.text = movie?.date
        
        //Set Viewcontroller title to movie name
         self.navigationItem.title = movie?.name
        
    }

 
}
