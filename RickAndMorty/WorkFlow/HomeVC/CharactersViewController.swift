//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Jarae on 26/7/23.
//

import UIKit

class CharactersViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(CustomCharactersCell.self, forCellReuseIdentifier: CustomCharactersCell.reuseID)
        return view
    }()
    
    var searchBar =  UISearchBar()
    
    private let viewModel: CharactersViewModel
    
    private var characters: [Result] = []
    var likedCharacters: [Result] = [] {
        didSet {
            let data = try! JSONEncoder().encode(likedCharacters)
            UserDefaults.standard.set(data, forKey: "qwerty")
        }
    }
    private var filteredCharacters: [Result] = []
    private var isFiltered: Bool = false
    
    init() {
        viewModel = CharactersViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = CharactersViewModel()
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetch()
    }

    func setUp() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setupNavigationController()
    }
    
    func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Characters"
        navigationController?.navigationBar.barTintColor = .systemBlue
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func fetch() {
        viewModel.fetchCharacters { chars in
            self.characters = chars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltered ? filteredCharacters.count : characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCharactersCell.reuseID, for: indexPath) as! CustomCharactersCell
        let model = isFiltered ? filteredCharacters[indexPath.row] : characters[indexPath.row]
        cell.config(character: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.delegate = self
        vc.config(character: characters[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

//MARK: - UISearchBarDelegates
extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(with: searchText)
        tableView.reloadData()
    }
}

extension CharactersViewController: CharacterDelegate {
    func didReceiveCharacter(_ id: Int) {
        if let index = characters.firstIndex(where: {$0.id == id}) {
            self.likedCharacters.append(self.characters[index])
            print(likedCharacters.count)
        }
    }
}

