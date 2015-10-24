//
//  BaseViewController.swift
//  TravelMate
//
//  Created by Błażej Chwiećko on 23/10/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var navBar:UINavigationBar=UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarToTheView()
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.frame.size.height = 65
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavBarToTheView()
    {
        navBar.frame=CGRectMake(0, 0, view.frame.size.width, 95)  // Here you can set you Width and Height for your navBar
        navBar.backgroundColor=(UIColor .blackColor())
        self.view.addSubview(navBar)
    }
}
