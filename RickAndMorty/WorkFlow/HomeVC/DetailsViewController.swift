//
//  DetailsViewController.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private lazy var characterPicture: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 160
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterName: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = 1
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var characterDescription: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.numberOfLines = 1
        view.textColor = .systemYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var episodesCount: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = Constants.Color.episodeColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .red
        view.addTarget(self, action:#selector(likeCharacter), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(CustomEpisodesCell.self, forCellReuseIdentifier: CustomEpisodesCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var delegate: CharacterDelegate?
    var likedOne: Result?
    
    private let viewModel: DetailsViewModel
    var isLiked: Bool?
    
    var episodesURLs = [String]()
    var episodes = [Episodes]()
    var color: UIColor?
    
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
        setupUI()
        fetchEpisodes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let id = likedOne?.id else {return}
        isLiked = UserdefaultStorage.shared.get(forKey: "\(id)")
        
        likeButton.setImage(UIImage(
            systemName: isLiked ?? false ? "heart.fill" : "heart",
            withConfiguration: Constants.ImageSize.config), for: .normal)
    }
    
    func setColor(status: String) -> UIColor {
        if status == "Alive" {
            return UIColor.systemGreen
        } else if status == "Dead" {
            return UIColor.systemRed
        } else {
            return UIColor.systemBlue
        }
    }
    
    func config(character to: Result) {
        color = setColor(status: to.status.rawValue)
        
        cimbinedLabel(text1: to.name, text2: " ( \(to.status.rawValue) ) ", color: color!)
        characterDescription.text = "( \(to.species.rawValue) - \(to.gender.rawValue) )"
        episodesCount.text = "  Episodes ( \(to.episode.count) )"
        
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
        
        likedOne = to
        self.episodesURLs = to.episode
    }
    
    func cimbinedLabel(text1: String, text2: String, color: UIColor) {
        let color1 = UIColor.black
        let color2 = color
        
        let attributedText = NSMutableAttributedString()
        
        let attributes1: [NSAttributedString.Key: Any] = [.foregroundColor: color1,]
        let attributedText1 = NSAttributedString(string: text1, attributes: attributes1)
        attributedText.append(attributedText1)
        
        let attributes2: [NSAttributedString.Key: Any] = [.foregroundColor: color2,]
        let attributedText2 = NSAttributedString(string: text2, attributes: attributes2)
        attributedText.append(attributedText2)
        
        characterName.attributedText = attributedText
    }
    
    func fetchEpisodes() {
        for i in 0...(episodesURLs.count - 1) {
            viewModel.fetchEpisodes(url: episodesURLs[i]) { ep in
                self.episodes.append(ep)
            }
        }
        self.tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        characterPicture.layer.borderWidth = 5
        characterPicture.layer.borderColor = color!.cgColor
        setupLayouts()
    }
    private func setupLayouts() {
        view.addSubviews(characterPicture, characterName, likeButton, characterDescription, episodesCount, tableView)
        
        NSLayoutConstraint.activate([
            characterPicture.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            characterPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterPicture.heightAnchor.constraint(equalToConstant: 320),
            characterPicture.widthAnchor.constraint(equalToConstant: 320),
            
            likeButton.bottomAnchor.constraint(equalTo: characterPicture.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: characterPicture.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            
            characterName.topAnchor.constraint(equalTo: characterPicture.bottomAnchor, constant: 20),
            characterName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            characterName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            
            characterDescription.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 10),
            characterDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            episodesCount.topAnchor.constraint(equalTo: characterDescription.bottomAnchor, constant: 10),
            episodesCount.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            episodesCount.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            episodesCount.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: episodesCount.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func likeCharacter() {
        guard let id = likedOne?.id else {return}
        guard let isLiked = isLiked else {return}
        
        if !isLiked {
            delegate?.didReceiveCharacter(id)
        } else {
            delegate?.removeCharacter(id)
        }
    
        likeButton.setImage(UIImage(
            systemName: viewModel.liked(String(id)),
            withConfiguration: Constants.ImageSize.config
        ), for: .normal)
    }
}

extension DetailsViewController: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomEpisodesCell.id, for: indexPath) as! CustomEpisodesCell
        cell.config(episode: episodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
