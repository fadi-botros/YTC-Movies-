//
//  MovieTableViewCell.swift
//  YTC Mobile Client
//
//  Created by apple on 12/17/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var runTimeTextLabel: UILabel!
    @IBOutlet weak var genreTextLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        makeShadow(view: containerView, shadowRadius: 1, shadowOpacity: 0.5)
        makeCornerViews(view: containerView, maskBounds: false, corner: 7)
        makeCornerViews(view: backgroundImage, maskBounds: true, corner: 7)
        makeCornerViews(view: movieImage, maskBounds: true, corner: 7)
   
    }
    
    
    //this function sets data to my cell using a parameter of type Movies
    func setMovieData(movie:Movie)
    {
        self.nameTextLabel.text = movie.name
        self.dateTextLabel.text = movie.date
        self.runTimeTextLabel.text = movie.runeTime + "min"
        self.descriptionTextView.text = movie.descriptionText
        self.genreTextLabel.text = movie.genre
        self.backgroundImage.kf.setImage(with: URL(string: movie.imgUrl))
    }
    
    //MARK: - Make Shadow
    func makeShadow(view: UIView , shadowRadius: Double , shadowOpacity: Double){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = CGFloat(shadowRadius)
        view.layer.shadowOpacity = Float(shadowOpacity)
    }
    
    //MARK: - make cornered views
    func makeCornerViews(view: UIView, maskBounds: Bool, corner: CGFloat) {
        view.layer.cornerRadius = corner
        view.layer.masksToBounds = maskBounds
    }


}
