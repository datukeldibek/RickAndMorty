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
        view.register(CustomCharactersCell.self, forCellReuseIdentifier: CustomCharactersCell.reuseID)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var likedChars: [Result] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "qwerty") else {return []}
            let results = try! JSONDecoder().decode([Result].self, from: data)
            return results
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        let rrr = likedChars
        print(rrr)
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setUp() {
        view.addSubview(tableView)
    
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
        likedChars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCharactersCell.reuseID, for: indexPath) as! CustomCharactersCell
        let model = likedChars[indexPath.row]
        cell.config(character: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.config(character: likedChars[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

