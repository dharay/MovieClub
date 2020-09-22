//
//  SearchUtility.swift
//  MovieClub
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import Foundation
import UIKit

struct SearchUtility {
    static func getSearches(searchString: String, baseValues: [Movie]) -> [Movie] {
        var wordDictionary: [String: [Movie]] = [:]
        var finalValues: [Movie] = []
        
        for i in baseValues {

            let words = i.title.split(separator: " ").map({String($0)})
            for word in words {
                if wordDictionary[word] == nil {
                    wordDictionary[word] = []
                }
                wordDictionary[word]?.append(i)
            }
            
        }
        let searchWords = searchString.split(separator: " ").map({String($0)})
        
        if searchWords.count == 0 {
            return []
        }
        
        for word in wordDictionary.keys{
            if word.lowercased().starts(with: searchWords[0].lowercased()) {
                for j in wordDictionary[word] ?? [] {
                    finalValues.append(j)
                }
            }
        }

        for i in 1..<searchWords.count {
            finalValues = finalValues.filter({ (movie) -> Bool in
                let words = movie.title.split(separator: " ").map({String($0)})

                for word in words {
                    if word.lowercased().starts(with: searchWords[i].lowercased()){
                        return true
                    }
                }

                return false
            })
        }

        return finalValues
    }
}


struct UIUtility {
    static func getBookedAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Tickets Booked!", message: "Yay!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
