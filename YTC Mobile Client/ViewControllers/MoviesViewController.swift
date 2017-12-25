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
    
    var refreshControl: UIRefreshControl?
    
    //Mark: Variables to be used in current Viewcontroller
    //includes Presenter, current page and searchText
    var moviesPresenter: MoviesPresenter = MoviesPresenter()
    
    var page = 1
    var searchText = ""
    
    private func startRefreshingAnimation() {
        //Show a loader to indicate the loading is on
        if #available(iOS 10.0, *) {
            moviesTableView.refreshControl?.beginRefreshing()
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    @objc func refreshInitiatedByUser(_ sender: UIRefreshControl) {
        // TODO: Improve UX
        moviesPresenter.MoviesArray.removeAll()
        moviesTableView.reloadData()
        moviesPresenter.requestMoviesList(page: page, searchText: searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare the refresh control
        // NOTE: This technique is only iOS > 10.0, you should use UITableViewController to support
        //    old versions of iOS.
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(refreshInitiatedByUser), for: .valueChanged)
            moviesTableView.refreshControl = refreshControl
        }
     
        startRefreshingAnimation()
     
     //Request the movie list on when view is loaded
     moviesPresenter.requestMoviesList(page: page, searchText: "")
     moviesPresenter.delegate = self
     
     configureSearch()
        
    }
    
    
    ///Passing current movie details to the MovieDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MovieDetailsViewController
        let row = (sender as? IndexPath)?.row
        let selectedMovie = moviesPresenter.MoviesArray[row!]
        destination.movie = selectedMovie
        
    }
    
    
}
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesPresenter.numberOfRowsInSection()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* This will load more movies when current row equals the of movies array
         includes both search and normal listing of movies.
        */
        if indexPath.row == moviesPresenter.MoviesArray.count - 1 {
            page += 1
            // This could be better done using the special (loader) cell in the end of the list
            MBProgressHUD.showAdded(to: self.view, animated: true)
            print(page)
            moviesPresenter.requestMoviesList(page: page, searchText: searchText)

        }
        
        //includes cell indentifying and setting it's data.
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        let movie = moviesPresenter.MoviesArray[indexPath.row]
        cell.setMovieData(movie:movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: indexPath)
    }
    
}

extension MoviesViewController: MoviesPresenterDelegate {
  
    //Delegate aimed to reload tableview after a request is done
    //reloading is done from my view Model.
    func moviesPresenterJustReloadTable(_ moviesPresenter: MoviesPresenter) {
        moviesTableView.reloadData()
        if #available(iOS 10.0, *) {
            moviesTableView.refreshControl?.endRefreshing()
        }
        MBProgressHUD.hide(for: self.view, animated: true)
     }
    
    func moviesPresenterJustHide(_ moviesPresenter: MoviesPresenter) {
        if #available(iOS 10.0, *) {
            moviesTableView.refreshControl?.endRefreshing()
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func moviesPresenter(_ moviesPresenter: MoviesPresenter, errorHappened error: Error?) {
        let alert = UIAlertController(title: "Error occured, check your internet connection", message: "Error", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        moviesPresenter.MoviesArray.removeAll()
        moviesPresenter.requestMoviesList(page: page, searchText: searchText)
        self.searchText = searchText
        MBProgressHUD.hide(for: self.view, animated: true)
        startRefreshingAnimation()
    }
    
    
}

