//
//  ViewController.swift
//  MovieClub
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import UIKit

final class MoviesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var tableSearchMode = false
    private var tableSearchData: [Movie] = []
    private var tablePlayingNowData: [Movie] = []
    private var imageCache: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        NetworkManager.shared.getNowPlaying {[weak self] (result) in
            DispatchQueue.main.async {
                self?.tablePlayingNowData = result
                self?.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableSearchMode ? tableSearchData.count : tablePlayingNowData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let dataSource = tableSearchMode ? tableSearchData : tablePlayingNowData
        let posterPath = dataSource[indexPath.row].poster_path
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.detailTextLabel?.text = "Rating: " +  dataSource[indexPath.row].vote_average.description
        if imageCache[posterPath] == nil {
            cell.imageView?.image = UIImage(named: "poster")
            cell.imageView?.contentMode = .scaleAspectFit
            NetworkManager.shared.getMovieImage(path: dataSource[indexPath.row].poster_path) {[weak self] (image) in
                
                DispatchQueue.main.async {
                    self?.imageCache[dataSource[indexPath.row].poster_path] = image
                    if tableView.hasRowAtIndexPath(indexPath: (indexPath as NSIndexPath) as IndexPath) {
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
            }
            
        } else {
            cell.imageView?.image = imageCache[dataSource[indexPath.row].poster_path]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSearchMode ? "searches found = \(tableSearchData.count)":"Movies playing now. swipe right on cell to book"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.isEmpty ?? true {
            self.tableSearchMode = false
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.tableSearchMode = false
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {return}
        
        self.tableSearchData = SearchUtility.getSearches(searchString: searchText, baseValues: tablePlayingNowData)
        tableSearchMode = true
        tableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableSearchMode = true
    }
    
}


extension UITableView {

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
