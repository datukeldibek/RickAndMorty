//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var delegate: CharacterDelegate?

    private lazy var characterPicture: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var characterName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var characterStatus: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .green
        return view
    }()
    
    private lazy var characterDescription: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 16, weight: .medium)
        view.numberOfLines = 1
        view.textColor = .systemYellow
        return view
    }()
    
    private lazy var episodesCount: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .red
        view.addTarget(self, action:#selector(likeCharacter), for: .touchUpInside)
        return view
    }()
    
   
    var likedOne: Result?
    
    private let viewModel: DetailsViewModel
    private var episodes = [String]()
    var isLiked: Bool = false
    
    init() {
        viewModel = DetailsViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = DetailsViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func config(character to: Result) {
        characterName.text = to.name
        characterStatus.text = "[\(to.status)]"
        characterDescription.text = "[\(to.species) - \(to.gender.rawValue)]"
        episodesCount.text = "  Episodes [\(to.episode.count)]"
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = ImageDownloader(
                urlString: to.image
            ).donwload()
            else {
                return
            }
            DispatchQueue.main.async {
                self.characterPicture.image = UIImage(data: data)
            }
        }
        episodes = to.episode
        
        likedOne = to
    }
    
    private func setUp() {
        view.backgroundColor = .white
        
        view.addSubview(characterPicture)
        characterPicture.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterPicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            characterPicture.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            characterPicture.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            characterPicture.heightAnchor.constraint(equalTo: characterPicture.widthAnchor)
        ])
        
        view.addSubview(characterName)
        characterName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterName.topAnchor.constraint(equalTo: characterPicture.bottomAnchor, constant: 20),
            characterName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        view.addSubview(characterStatus)
        characterStatus.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterStatus.topAnchor.constraint(equalTo: characterPicture.bottomAnchor, constant: 23),
            characterStatus.leadingAnchor.constraint(equalTo: characterName.trailingAnchor, constant: 10),
        ])
        
        view.addSubview(characterDescription)
        characterDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            characterDescription.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 10),
            characterDescription.leadingAnchor.constraint(equalTo: characterName.leadingAnchor),
        ])
        
        view.addSubview(episodesCount)
        episodesCount.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodesCount.topAnchor.constraint(equalTo: characterDescription.bottomAnchor, constant: 20),
            episodesCount.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            episodesCount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            episodesCount.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: characterPicture.bottomAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    @objc func likeCharacter() {
        guard let id = likedOne?.id else {return}
        delegate?.didReceiveCharacter(id)
        likeButton.setImage(UIImage(systemName: viewModel.liked()), for: .normal)
    }
}
