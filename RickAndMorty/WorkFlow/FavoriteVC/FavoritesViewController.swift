//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Jarae on 27/7/23.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constants.Color.baseColor
        view.register(CustomCharactersCell.self, forCellReuseIdentifier: CustomCharactersCell.id)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var charactersViewController: CharactersViewController?
    
    var likedCharsFromUD: [Result] {
        get {
            let data = UserdefaultStorage.shared.getDataWithKey(forKey: .favoritesArray)
            let results = try? JSONDecoder().decode([Result].self, from: data)
            print("##### Result on Fvorits VC -> \(results)")
            return results ?? []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func setup() {
        view.backgroundColor = Constants.Color.baseColor
        setupLayouts()
    }

    func setupLayouts() {
        view.addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likedCharsFromUD.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCharactersCell.id, for: indexPath) as? CustomCharactersCell else {return UITableViewCell()}
        let model = likedCharsFromUD[indexPath.row]
        cell.config(character: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegateViewController = charactersViewController else {return}
        let detailsViewController = DetailsViewController()
//        let vc2 = CharactersViewController()
//        vc.delegate = vc2
        
//        guard let viewControllers = self.navigationController?.viewControllers else {return}
//
//        for aViewController in viewControllers {
//            if aViewController is CharactersViewController {
//                detailsViewController.delegate = aViewController as! CharacterDelegate
//            }
//        }
        
        detailsViewController.delegate = delegateViewController
        detailsViewController.config(character: likedCharsFromUD[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
