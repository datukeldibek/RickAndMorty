//
//  DetailsViewModel.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import Foundation

class DetailsViewModel {
    
    var isLiked: Bool = false
    
    func liked() -> String {
        if !isLiked {
            isLiked = true
            //UserDefaults.standard.set(item, forKey: key)
            return "heart.fill"
            
        } else {
            isLiked = false
            return "heart"
        }
    }
    
}
