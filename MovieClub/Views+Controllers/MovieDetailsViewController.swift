//
//  MovieDetailsViewController.swift
//  MovieClub
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movieId: String = "0"
    private var completionCounter = 0 {
        didSet {
            if self.completionCounter > 2 {
                loader.stopAnimating()
            }
        }
        
    }
    private var movie: Movie?
    private var similarMovies: [Movie] = []
    private var movieReviews: [MovieReview] = []
    private var movieCrew: [Crew] = []
    
    private let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loader)
        loader.startAnimating()
        networkCalls()
        // Do any additional setup after loading the view.
    }
    private func networkCalls() {
        // could use operation and operationQueues, but this simpler solution works too
        NetworkManager.shared.getMovieDetails(id: movieId) {[weak self] (movie) in
            DispatchQueue.main.async {
                self?.movie = movie
                self?.completionCounter += 1
            }
        }
        NetworkManager.shared.getMovieCredits(id: movieId) {[weak self] (crew) in
            DispatchQueue.main.async {
                self?.movieCrew = crew
                self?.completionCounter += 1
            }
        }
        NetworkManager.shared.getMovieReviews(id: movieId) {[weak self] (movieReviews) in
            DispatchQueue.main.async {
                self?.movieReviews = movieReviews
                self?.completionCounter += 1
            }
        }
        NetworkManager.shared.getSimilarMovies(id: movieId) {[weak self] (movies) in
            DispatchQueue.main.async {
                self?.similarMovies = movies
                self?.completionCounter += 1
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
