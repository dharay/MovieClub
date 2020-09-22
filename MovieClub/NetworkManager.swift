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
            // baseURLString should not be nil/invalid
            return URL(string: baseURLString)!
        }
    }
    
    private var posterBaseURL: URL {
        get {
            return URL(string: "https://image.tmdb.org/t/p/original")!
        }
    }
    private let apiKeyV3 = "e961b288500e4b7ba8af8cbba1da736f"
    private let apiKeyV4 = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlOTYxYjI4ODUwMGU0YjdiYThhZjhjYmJhMWRhNzM2ZiIsInN1YiI6IjU3Zjc2Y2FkOTI1MTQxMjU1NTAwMGY3OCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ZMZlYjwQCwOGwItT7yiWscqNYhCDz96gsWTWZj1fBl0"
    
    func getNowPlaying(closure: @escaping (_ result: [NowPlaying]) -> ()) {
        var nowPlayingURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        var result: [NowPlaying] = []

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
                    result = nowPlayingResponse.results
                    closure(result)
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
    
    
}

struct NowPlayingResponse: Codable {
    var results: [NowPlaying]
}

struct NowPlaying: Codable {
    let title: String
    let vote_average: Float
    let original_language: String
    let release_date: String
    let poster_path: String
}
