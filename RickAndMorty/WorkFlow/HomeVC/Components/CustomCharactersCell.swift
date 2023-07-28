//
//  CustomCharactersCell.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import UIKit

class CustomCharactersCell: UITableViewCell {

    static let reuseID = String(describing: CustomCharactersCell.self)
    let networkService = NetworkService()
    
    private lazy var characterPicture: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = self.frame.height / 3.0
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var characterName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.numberOfLines = 0
        return view
    }()

    override func layoutSubviews() {
        setUp()
    }
    
    func config(character to: Result) {
        characterName.text = to.name
        if let image = UIImage(data: networkService.getImage(url: to.image)) {
            characterPicture.image = image
        }
    }
    
    private func setUp() {
        contentView.addSubview(characterPicture)
        characterPicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterPicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            characterPicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            characterPicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            characterPicture.widthAnchor.constraint(equalToConstant: 70),
            characterPicture.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        contentView.addSubview(characterName)
        characterName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            characterName.leadingAnchor.constraint(equalTo: characterPicture.trailingAnchor, constant: 20),
        ])
    }
}
