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
        let vc3 = UINavigationController(rootViewController: StoryboardScene.ChatTableViewController.initialScene.instantiate())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "message")
        
        vc1.title = "ホーム"
        vc2.title = "検索"
        vc3.title = "チャット"
        
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        
        let itemAppearance = {
            let appearance = UITabBarItemAppearance()
            appearance.normal.iconColor = .lightGray
            appearance.normal.titleTextAttributes = normalAttributes
            appearance.selected.iconColor = .white
            appearance.selected.titleTextAttributes = selectedAttributes
            return appearance
        }()
        
        let tabBarAppearance = {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .systemCyan
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            return appearance
        }()
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        setViewControllers([vc1,vc2,vc3], animated: true)
    }
    
    
    
}
