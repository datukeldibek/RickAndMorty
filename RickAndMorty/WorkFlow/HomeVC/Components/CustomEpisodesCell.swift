//
//  CustomEpisodesCell.swift
//  RickAndMorty
//
//  Created by Jarae on 10/8/23.
//

import UIKit

class CustomEpisodesCell: UITableViewCell {
    
    private lazy var episodeID: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.numberOfLines = 2
        view.text = "Name\nAirDate"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var episodeInfo: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .light)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        setupLayouts()
    }
    
    func config(episode to: Episodes) {
        episodeID.text = "\(to.id)  -"
        episodeInfo.text = "\(to.name)\n\(to.airDate)"
    }
    
    private func setupLayouts() {
        contentView.addSubviews(episodeID, title, episodeInfo)
        
        NSLayoutConstraint.activate([
            episodeID.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            episodeID.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: episodeID.trailingAnchor, constant: 10),
            
            episodeInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            episodeInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 130)
        ])
    }
}
