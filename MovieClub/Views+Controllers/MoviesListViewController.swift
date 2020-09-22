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
    private var tableSearchData: [String] = []
    private var tablePlayingNowData: [NowPlaying] = []
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
        
        cell.textLabel?.text = tablePlayingNowData[indexPath.row].title
        cell.detailTextLabel?.text = "Rating: " +  tablePlayingNowData[indexPath.row].vote_average.description
        if imageCache[tablePlayingNowData[indexPath.row].poster_path] == nil {
            cell.imageView?.image = UIImage(named: "poster")
            cell.imageView?.contentMode = .scaleAspectFit
            NetworkManager.shared.getMovieImage(path: tablePlayingNowData[indexPath.row].poster_path) {[weak self] (image) in
                self?.imageCache[self?.tablePlayingNowData[indexPath.row].poster_path ?? "default"] = image
                DispatchQueue.main.async {
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                
            }
            
        } else {
            cell.imageView?.image = imageCache[tablePlayingNowData[indexPath.row].poster_path]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableSearchMode ? "searches found = \(tableSearchData.count)":"Movies playing now. swipe right on cell to book"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


