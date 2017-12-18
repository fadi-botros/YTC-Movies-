//
//  MoviesViewModel.swift
//  YTC Mobile Client
//
//  Created by apple on 12/17/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

protocol JustReloading {
    func JustReloadTable()
    func JustHide()
}

class MoviesViewModel: NSObject {
    
    
    //Mark: Variables
    var MoviesArray = [Movie]()
    var delegate: JustReloading?
    let provider = MoyaProvider<MyService>()

    override init() {

    }
    
    /**
   This function requests movie list based on two parameters
     -Page
     -SearchText
     
     it includes provider variables which is made by Moya library to connect to our Api,
     In case of success
     JSON response is handled using SwiftyJSON
     and then a Movie object is created and appended to an Movie Array
     then a delegate is used to reloadTableView
     In case of error
     error is printed.
     
 **/
    
    func requestMoviesList(page: Int, searchText: String) {
        provider.request(.listMovies(page: page, searchText: searchText)) { result in
            switch result {
            case let .success(moyaResponse):
                 let json = JSON(moyaResponse.data)
                 let movies = json["data"]["movies"].arrayValue
                 for movie in movies {
                    let movieObject = Movie(name: movie["title_english"].stringValue, image_url: movie["medium_cover_image"].stringValue, date: movie["year"].stringValue, runTime: movie["runtime"].stringValue, genre: movie["genres"].arrayValue[0].stringValue, descriptionText: movie["description_full"].stringValue )
                    self.MoviesArray.append(movieObject)
                }
                 if !movies.isEmpty {
                self.delegate?.JustReloadTable()
                 } else {
                self.delegate?.JustHide()
            }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    
    // returns number of elements in movies array
    
    func numberOfRowsInSection() -> Int {
        return MoviesArray.count
    }

  


}
