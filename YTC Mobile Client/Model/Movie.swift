//
//  Movie.swift
//  YTC Mobile Client
//
//  Created by apple on 12/17/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import Foundation

// No need for NSObject here, you don't use Key-Value Observation, dynamic functions/variables, @objc
//   so it is better in terms of performance not to use this
class Movie {
    
    var imgUrl : String!
    var name : String!
    var date : String!
    var runeTime: String!
    var genre: String!
    var descriptionText: String!
    
    init(dictionary: [String:Any])
    {
        imgUrl = dictionary["img_url"] as? String
        name = dictionary["name"] as? String
        date = dictionary["date"] as? String
        runeTime = dictionary["runeTime"] as? String
        genre = dictionary["genre"] as? String
        descriptionText = dictionary["descriptionText"] as? String

    }
    init(name: String, image_url: String, date: String, runTime: String, genre: String, descriptionText: String)
    {
        self.name = name
        self.imgUrl = image_url
        self.date = date
        self.runeTime = runTime
        self.genre = genre
        self.descriptionText = descriptionText

    }

}
