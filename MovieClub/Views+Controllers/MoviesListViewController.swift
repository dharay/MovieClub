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
    private var tableMode: TableMode = .all
    private var tableSearchData: [Movie] = []
    private var tablePlayingNowData: [Movie] = []
    private var tableRecentSearches: [Movie] = []
    private var imageCache: [String: UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        let clearSearchButton = UIBarButtonItem(title: "Clear Search", style: .plain, target: self, action: #selector(clearSearch))
        self.navigationItem.setLeftBarButton(clearSearchButton, animated: true)

        NetworkManager.shared.getNowPlaying {[weak self] (result) in
            DispatchQueue.main.async {
                self?.tablePlayingNowData = result
                self?.tableView.reloadData()
            }
        }
        
        self.navigationItem.title = "Movie Club"
    }
    @objc func clearSearch () {
        tableMode = .all
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableMode {
        case .all:
            return tablePlayingNowData.count
        case .search:
            return tableSearchData.count
        case .recent:
            return tableRecentSearches.count
        }
      
    }
    
    private func getDataSource() -> [Movie] {
        switch tableMode {
         case .all:
             return tablePlayingNowData
         case .search:
             return tableSearchData
         case .recent:
             return tableRecentSearches
         }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let dataSource = getDataSource()
        let posterPath = dataSource[indexPath.row].poster_path ?? ""
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.detailTextLabel?.text = "Rating: " +  dataSource[indexPath.row].vote_average.description
        if imageCache[posterPath] == nil {
            cell.imageView?.image = UIImage(named: "poster")
            cell.imageView?.contentMode = .scaleAspectFit
            guard let posterPath = dataSource[indexPath.row].poster_path else {
                return cell
            }
            NetworkManager.shared.getMovieImage(path: posterPath) {[weak self] (image) in
                
                DispatchQueue.main.async {
                    self?.imageCache[posterPath] = image
                    if tableView.hasRowAtIndexPath(indexPath: (indexPath as NSIndexPath) as IndexPath) {
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
            }
            
        } else {
            cell.imageView?.image = imageCache[dataSource[indexPath.row].poster_path ?? ""]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableMode {
         case .all:
             return "Movies playing now. swipe right on cell to book"
         case .search:
             return "searches found = \(tableSearchData.count)."
         case .recent:
             return ""
         }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = getDataSource()
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detail") as! MovieDetailsViewController
        detailVC.movieId = dataSource[indexPath.row].id.description
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookAction = UIContextualAction(style: .destructive, title: "Book") { (action, view, handler) in
            let alert = UIUtility.getBookedAlert()
            self.present(alert, animated: true, completion: nil)
        }
        bookAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [bookAction])
        return configuration
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text?.isEmpty ?? true {
            tableMode = .all
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        tableMode = .all
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? true {
            tableMode = .recent
        } else {
            tableMode = .search
            tableSearchData = SearchUtility.getSearches(searchString: searchText, baseValues: tablePlayingNowData)
        }

        tableView.reloadData()
    }

}
enum TableMode {
    case all
    case search
    case recent
}

extension UITableView {

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
