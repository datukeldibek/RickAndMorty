//
//  CustomCharactersCell.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import UIKit

class CustomCharactersCell: UITableViewCell {
    
    private lazy var cellLayer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.23
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterPicture: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = self.frame.height / 3.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var arrow: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        setupUI()
    }
    
    func config(character to: Result) {
        characterName.text = to.name
        if let image = UIImage(data: NetworkService.shared.getImage(url: to.image)) {
            characterPicture.image = image
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = Constants.Color.baseColor
        setupLayouts()
    }
    
    private func setupLayouts() {
        contentView.addSubview(cellLayer)
        cellLayer.addSubviews(characterPicture, characterName, arrow)
        cellLayer.addEdgesConstraints(constant: 10, superView: contentView)
        
        NSLayoutConstraint.activate([
            characterPicture.topAnchor.constraint(equalTo: cellLayer.topAnchor, constant: 15),
            characterPicture.leadingAnchor.constraint(equalTo: cellLayer.leadingAnchor, constant: 30),
            characterPicture.bottomAnchor.constraint(equalTo: cellLayer.bottomAnchor, constant: -15),
            characterPicture.widthAnchor.constraint(equalToConstant: 80),
            
            characterName.centerYAnchor.constraint(equalTo: cellLayer.centerYAnchor),
            characterName.leadingAnchor.constraint(equalTo: characterPicture.trailingAnchor, constant: 20),
            
            arrow.centerYAnchor.constraint(equalTo: cellLayer.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: cellLayer.trailingAnchor, constant: -15),
            arrow.heightAnchor.constraint(equalToConstant: 15),
            arrow.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
}
