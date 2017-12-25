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

// The delegate protocol has a naming convention by Apple, try to immitate that of UITableViewDelegate,
//    UITextFieldDelegate, or any delegate
// Made the delegate inherit AnyObject to be allowed to be used as "weak var"
protocol MoviesPresenterDelegate: AnyObject {
    func moviesPresenterJustReloadTable(_ moviesPresenter: MoviesPresenter)
    func moviesPresenterJustHide(_ moviesPresenter: MoviesPresenter)
    // This when an error happen, we need the error to present it if something happens
    func moviesPresenter(_ moviesPresenter: MoviesPresenter, errorHappened error: Error?)
}

// This is a presenter, not a ViewModel
// The viewModel is just a group of observables
// (In iOS/macOS Development you can use Key-Value Observation, so, use "@objc dynamic" before any
//    variable you want it to be observable)

class MoviesPresenter {
    
    
    //Mark: Variables
    var MoviesArray = [Movie]()
    // Delegates must be weak referenced to avoid retain cycles
    weak var delegate: MoviesPresenterDelegate?
    let provider = MoyaProvider<MyService>()

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
                self.delegate?.moviesPresenterJustReloadTable(self)
                 } else {
                self.delegate?.moviesPresenterJustHide(self)
            }
                
            case let .failure(error):
                self.delegate?.moviesPresenter(self, errorHappened: error)
            }
        }
    }
    
    
    /// Returns: number of elements in movies array
    func numberOfRowsInSection() -> Int {
        return MoviesArray.count
    }

  


}
