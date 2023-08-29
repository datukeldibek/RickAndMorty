//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Jarae on 28/7/23.
//

import UIKit

class TabbarControllers: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = Constants.Color.baseColor
        
        let charactersViewController = CharactersViewController()
        let favoritesViewController = FavoritesViewController()
        
//        favoritesViewController.charactersViewController = charactersViewController
        
        let charactersNavigationController = UINavigationController(rootViewController: charactersViewController)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        
        
        charactersNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"),selectedImage: UIImage(systemName: "house.fill"))
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"),selectedImage: UIImage(systemName: "heart.fill"))
        
//        charactersNavigationController.navigationBar.isTranslucent = false
//        charactersNavigationController.navigationBar.barStyle = .black
//        charactersNavigationController.navigationBar.tintColor = .white
//
//        favoritesNavigationController.navigationBar.isTranslucent = false
        
        self.viewControllers = [charactersNavigationController, favoritesNavigationController]
    }
}
