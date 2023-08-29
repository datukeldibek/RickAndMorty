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
        view.backgroundColor = Constants.Color.baseColor
        view.separatorStyle = .none
        view.register(CustomCharactersCell.self, forCellReuseIdentifier: CustomCharactersCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var characters: [Result] = []
    
    var likedCharsFromUD: [Result] {
        get {
//            let data = UserdefaultStorage.shared.getDataWithKey(forKey: .favoritesArray)
//            let results = try! JSONDecoder().decode([Result].self, from: data)
            return []
        }
    }
    
    var likedCharacters: [Result] = []
//    {
//        didSet {
//            let data = try! JSONEncoder().encode(likedCharacters)
//            UserdefaultStorage.shared.saveWithKey(data, forKey: .favoritesArray)
//        }
//    }
    
    var filteredCharacters: [Result] = []
    var isFiltered = false
    private let viewModel: CharactersViewModel
    
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
        setupUI()
        fetchCharacters()
        let data = UserdefaultStorage.shared.getDataWithKey(forKey: .favoritesArray)
        do {
            self.likedCharacters = try JSONDecoder().decode([Result].self, from: data)
        }
        catch {
            
        }
//        likedCharacters = likedCharsFromUD
    }
    
    func setupUI() {
        navigationItem.title = "CHARACTERS"
        view.backgroundColor = Constants.Color.baseColor
        searchBar.delegate = self
        setupLayouts()
    }
    
    func setupLayouts() {
        view.addSubviews(searchBar, tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchCharacters() {
        viewModel.fetchCharacters { chars in
            self.characters = chars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func handleMoveToTrash(_ id: Int) {
        characters = characters.filter { $0.id != id }
        tableView.reloadData()
    }
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltered ? filteredCharacters.count : characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCharactersCell.id, for: indexPath) as! CustomCharactersCell
        let model = isFiltered ? filteredCharacters[indexPath.row] : characters[indexPath.row]
        cell.config(character: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.delegate = self
        vc.config(character: characters[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "DELETE") { [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(self?.characters[indexPath.row].id ?? 0)
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
}

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltered = false
        } else {
            isFiltered = true
            filteredCharacters = characters.filter{ $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}

extension CharactersViewController: CharacterDelegate {
    func didReceiveCharacter(_ id: Int) {
        if let index = characters.firstIndex(where: {$0.id == id}) {
            self.likedCharacters.append(self.characters[index])
            guard let data = try? JSONEncoder().encode(self.likedCharacters) else {return}
            UserdefaultStorage.shared.saveWithKey(data, forKey: .favoritesArray)
            print("##### likedCharacters after save -> \(likedCharacters)")
            print(likedCharacters.count)
        }
    }
    
    func removeCharacter(_ id: Int) {
        self.likedCharacters = self.likedCharacters.filter { $0.id != id }
        guard let data = try? JSONEncoder().encode(self.likedCharacters) else {return}
        UserdefaultStorage.shared.saveWithKey(data, forKey: .favoritesArray)
        print("##### likedCharacters after remove -> \(likedCharacters)")
    }
}
