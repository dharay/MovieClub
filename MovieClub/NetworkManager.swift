//
//  NetworkManager.swift
//  MovieClub
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private let baseURLString = "https://api.themoviedb.org/"
    
    private var baseURL: URL {
        get {
            return URL(string: baseURLString)!
        }
    }
    
    private let posterBaseURL: URL = URL(string: "https://image.tmdb.org/t/p/original")!
    private let apiKeyV3 = "e961b288500e4b7ba8af8cbba1da736f"

    
    func getNowPlaying(closure: @escaping (_ result: [Movie]) -> ()) {
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        nowPlayingURL?.path = "/3/movie/now_playing"
        nowPlayingURL?.queryItems = [URLQueryItem(name: "api_key", value: apiKeyV3)]
        guard let nowPlayingURLSafe = nowPlayingURL, let url = nowPlayingURLSafe.url else {
            // handle invalid URL
            print("invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, resp, err) in
            if let data = data {
                let nowPlayingResponse: NowPlayingResponse? = try? JSONDecoder().decode(NowPlayingResponse.self, from: data)
                if let nowPlayingResponse = nowPlayingResponse {
                    closure(nowPlayingResponse.results)
                } else {
                    // handle improper JSON decode
                    print("improper JSON decode")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
    }
    func getMovieImage(path: String, closure: @escaping (_ result: UIImage) -> ()){
        var imageURL = posterBaseURL
        imageURL.appendPathComponent(path)
        
        let task = URLSession.shared.dataTask(with: imageURL) {(data, resp, err) in
            if let data = data {
                let image: UIImage? = UIImage(data: data)
                if let image = image {
                    closure(image)
                } else {
                    //handle image conversion from data failed
                    print("image error")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
        
    }
    
    func getMovieDetails(id: String,closure: @escaping (_ result: Movie) -> ()) {
        //TODO: change to appropriate name for 'nowPlayingURL' for all below functions
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        nowPlayingURL?.path = "/3/movie/\(id)"
        nowPlayingURL?.queryItems = [URLQueryItem(name: "api_key", value: apiKeyV3)]
        guard let nowPlayingURLSafe = nowPlayingURL, let url = nowPlayingURLSafe.url else {
            // handle invalid URL
            print("invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, resp, err) in
            if let data = data {
                let movieResponse: Movie? = try? JSONDecoder().decode(Movie.self, from: data)
                if let movieResponse = movieResponse {

                    closure(movieResponse)
                } else {
                    // handle improper JSON decode
                    print("improper JSON decode")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
    }
    
    func getMovieReviews(id: String,closure: @escaping (_ result: [MovieReview]) -> ()) {
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        nowPlayingURL?.path = "/3/movie/\(id)/reviews"
        nowPlayingURL?.queryItems = [URLQueryItem(name: "api_key", value: apiKeyV3)]
        guard let nowPlayingURLSafe = nowPlayingURL, let url = nowPlayingURLSafe.url else {
            // handle invalid URL
            print("invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, resp, err) in
            if let data = data {
                let movieResponse: MovieReviews? = try? JSONDecoder().decode(MovieReviews.self, from: data)
                if let movieResponse = movieResponse {

                    closure(movieResponse.results)
                } else {
                    // handle improper JSON decode
                    print("improper JSON decode")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
    }
    
    func getMovieCredits(id: String,closure: @escaping (_ result: [Crew]) -> ()) {
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        nowPlayingURL?.path = "/3/movie/\(id)/credits"
        nowPlayingURL?.queryItems = [URLQueryItem(name: "api_key", value: apiKeyV3)]
        guard let nowPlayingURLSafe = nowPlayingURL, let url = nowPlayingURLSafe.url else {
            // handle invalid URL
            print("invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, resp, err) in
            if let data = data {
                let movieResponse: MovieCreditsResponse? = try? JSONDecoder().decode(MovieCreditsResponse.self, from: data)
                if let movieResponse = movieResponse {
                    
                    closure(movieResponse.crew)
                } else {
                    // handle improper JSON decode
                    print("improper JSON decode")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
    }
    
    func getSimilarMovies(id: String,closure: @escaping (_ result: [Movie]) -> ()) {
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        nowPlayingURL?.path = "/3/movie/\(id)/similar"
        nowPlayingURL?.queryItems = [URLQueryItem(name: "api_key", value: apiKeyV3)]
        guard let nowPlayingURLSafe = nowPlayingURL, let url = nowPlayingURLSafe.url else {
            // handle invalid URL
            print("invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) {(data, resp, err) in
            if let data = data {
                let movieResponse: NowPlayingResponse? = try? JSONDecoder().decode(NowPlayingResponse.self, from: data)
                if let movieResponse = movieResponse {
                    
                    closure(movieResponse.results)
                } else {
                    // handle improper JSON decode
                    print("improper JSON decode")
                }
                
            } else {
                // handle data nil error
                print("data nil")
            }
        }

        task.resume()
    }


}

struct NowPlayingResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable {
    let title: String
    let id: Int
    let vote_average: Float
    let original_language: String
    let release_date: String
    let poster_path: String
    let overview: String?
}

struct MovieReviews: Codable {
    let results: [MovieReview]
}

struct MovieReview: Codable {
    let author: String
    let content: String
}

struct MovieCreditsResponse: Codable {
    let crew: [Crew]
}
struct Crew: Codable {
    let job: String
    let name: String
}

