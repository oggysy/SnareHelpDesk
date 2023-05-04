//
//  ManiTabBarViewController.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: StoryboardScene.HomeViewController.initialScene.instantiate())
        let vc2 = UINavigationController(rootViewController: StoryboardScene.SearchViewController.initialScene.instantiate())

        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")

        vc1.title = "Home"
        vc2.title = "Search"

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .systemCyan

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = .lightGray
        itemAppearance.normal.titleTextAttributes = normalAttributes
        itemAppearance.selected.iconColor = .white
        itemAppearance.selected.titleTextAttributes = selectedAttributes
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

        setViewControllers([vc1,vc2], animated: true)
    }



}
