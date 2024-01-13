//
//  ViewController.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        createTabBar()
    }
    func createTabBar(){
        let vc1=UINavigationController(rootViewController: HomeViewController())
        let vc2=UINavigationController(rootViewController: NotificationViewController())
        let vc3=UINavigationController(rootViewController: DirectMessagesViewController())
        let vc4=UINavigationController(rootViewController: SearchViewController())
        vc1.tabBarItem.image=UIImage(systemName: "house")
        vc1.tabBarItem.selectedImage=UIImage(systemName: "house.fill")
        vc2.tabBarItem.image=UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image=UIImage(systemName: "bell")
        vc3.tabBarItem.selectedImage=UIImage(systemName: "bell.fill")
        vc4.tabBarItem.image=UIImage(systemName: "envelope")
        vc4.tabBarItem.selectedImage=UIImage(systemName: "envelope.fill")
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
        

    }


}

