//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import Foundation

class CharactersViewModel {
    
    let networkService: NetworkService
    
    private var characters: [Result] = []
    private var filteredCharacters: [Result] = []
    
    init() {
        self.networkService = NetworkService()
    }
    
    func fetchCharacters(complition: @escaping ([Result]) -> ()) {
        networkService.requestCharacters { characters in
            complition(characters)
        }
    }
    
    func filter(with text: String) {
        filteredCharacters = characters.filter {
            $0.name.lowercased().contains(text.lowercased())
        }
    }
}
