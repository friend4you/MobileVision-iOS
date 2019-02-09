//
//  Appearance.swift
//  MobileVision
//
//  Created by Vlad Arsenyuk on 2/9/19.
//  Copyright © 2019 Arseniuk. All rights reserved.
//

import UIKit

struct Appearance {
    
    static func style() {
        Appearance.styleMainNavigationBar()
    }
    
    static func styleMainNavigationBar() {
        let navBar = UINavigationBar.appearance()
        
        navBar.shadowImage = UIImage()
    }
}

