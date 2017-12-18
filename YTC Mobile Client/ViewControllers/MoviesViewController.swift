//
//  ViewController.swift
//  YTC Mobile Client
//
//  Created by apple on 12/16/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTableView: UITableView!
    
    //Mark: Variables to be used in current Viewcontroller
    //includes ViewModel, current page and searchText
    var moviesViewModel: MoviesViewModel = MoviesViewModel()
    
    var page = 1
    var searchText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
     //Show a loader to indicate the loading is on
     MBProgressHUD.showAdded(to: self.view, animated: true)
     
     //Request the movie list on when view is loaded
     moviesViewModel.requestMoviesList(page: page, searchText: "")
     moviesViewModel.delegate = self
     
     configureSearch()
        
    }
    
    
    ///Passing current movie details to the MovieDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MovieDetailsViewController
        let row = (sender as? IndexPath)?.row
        let selectedMovie = moviesViewModel.MoviesArray[row!]
        destination.movie = selectedMovie
        
    }
    
    
}
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesViewModel.numberOfRowsInSection()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* This will load more movies when current row equals the of movies array
         includes both search and normal listing of movies.
        */
        if indexPath.row == moviesViewModel.MoviesArray.count - 1 {
            page += 1
            MBProgressHUD.showAdded(to: self.view, animated: true)
            print(page)
            moviesViewModel.requestMoviesList(page: page, searchText: searchText)

        }
        
        //includes cell indentifying and setting it's data.
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = moviesViewModel.MoviesArray[indexPath.row]
        cell.setMovieData(movie:movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }
    
}

extension MoviesViewController: JustReloading {
  
    //Delegate aimed to reload tableview after a request is done
    //reloading is done from my view Model.
    func JustReloadTable() {
        moviesTableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
     }
    
    func JustHide() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    //Adding search bar and configuring it's title
    private func configureSearch() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    
    //requesting movie list based on searchtext on my search bar
    //request is intiated once text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        moviesViewModel.MoviesArray.removeAll()
        moviesViewModel.requestMoviesList(page: page, searchText: searchText)
        self.searchText = searchText
        MBProgressHUD.hide(for: self.view, animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    
}

