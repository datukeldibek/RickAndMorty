//
//  EpisodesModel.swift
//  RickAndMorty
//
//  Created by Jarae on 19/8/23.
//

import Foundation

struct Episodes: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
