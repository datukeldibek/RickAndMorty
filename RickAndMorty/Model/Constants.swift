//
//  Constants.swift
//  RickAndMorty
//
//  Created by Jarae on 26/7/23.
//

import UIKit

enum Constants {
    enum API {
        static let baseURL = URL(string: "https://rickandmortyapi.com/api/character")!
    }
    
    enum Color {
        static let baseColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        static let episodeColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    }
    
    enum ImageSize {
        static let config = UIImage.SymbolConfiguration(pointSize: 24)
    }
}
