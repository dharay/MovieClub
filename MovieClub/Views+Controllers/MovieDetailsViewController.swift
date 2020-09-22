//
//  MovieDetailsViewController.swift
//  MovieClub
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!

    var movieId: String = "0"
    private var completionCounter = 0 {
        didSet {
            if self.completionCounter == 4 {
                loader.stopAnimating()
                loadUI()
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
    }
    
    private func networkCalls() {
        // could use operation and operationQueues, but this simpler solution works too
        //TODO: pass closure for failures too
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
    
    func loadUI(){
        self.navigationItem.title = movie?.title
        let overView = UILabel()
        overView.text = "Overview"
        overView.textAlignment = .center
        overView.backgroundColor = .lightGray
        stackView.addArrangedSubview(overView)
        
        let overviewDetails = UILabel()
        overviewDetails.text = movie?.overview
        overviewDetails.numberOfLines = 0
        stackView.addArrangedSubview(overviewDetails)
        
        let crewLabel = UILabel()
        crewLabel.text = "Crew"
        crewLabel.textAlignment = .center
        crewLabel.backgroundColor = .lightGray
        stackView.addArrangedSubview(crewLabel)
        
        var i = 0
        for crew in self.movieCrew {
            let label = UILabel()
            label.text = crew.job + " - " + crew.name
            label.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(label)
            i+=1
            if i > 5 {
                break
            }
        }
        
        let reviews = UILabel()
        reviews.text = "Reviews"
        reviews.textAlignment = .center
        reviews.backgroundColor = .lightGray
        stackView.addArrangedSubview(reviews)
        
        if self.movieReviews.count == 0{
            let noreviews = UILabel()
            noreviews.text = "no reviews available"
            stackView.addArrangedSubview(noreviews)
        } else {
            for i in 0..<movieReviews.count {
                let review = UILabel()
                review.text = movieReviews[i].author + " - " + movieReviews[i].content
                review.numberOfLines = 0
                review.layer.borderColor = UIColor.black.cgColor
                review.layer.borderWidth = 1
                stackView.addArrangedSubview(review)
                if i > 5 {
                    break
                }
            }
        }
        
        let similar = UILabel()
        similar.text = "Similar movies"
        similar.textAlignment = .center
        similar.backgroundColor = .lightGray
        stackView.addArrangedSubview(similar)
        
        if self.similarMovies.count == 0{
            let noreviews = UILabel()
            noreviews.text = "no similar movies available"
            stackView.addArrangedSubview(noreviews)
        } else {
            for i in 0..<similarMovies.count {
                let review = UILabel()
                review.text = similarMovies[i].title
                stackView.addArrangedSubview(review)
                if i > 5 {
                    break
                }
            }
        }
            
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = stackView.frame.size

        
    }

}
