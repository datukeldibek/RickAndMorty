//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Jarae on 26/7/23.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func requestCharacters(completion: @escaping ([Result]) -> Void) {
        
        let request = URLRequest(url: Constants.API.baseURL)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let model = try JSONDecoder().decode(Characters.self, from: data)
                completion(model.results)
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func getImage(url: String) -> Data {
        guard let data = ImageDownloader(
            urlString: url
        ).donwload()
        else { return Data() }
        return data
    }
    private func decode<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
