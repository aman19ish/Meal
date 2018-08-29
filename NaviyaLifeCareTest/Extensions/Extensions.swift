//
//  Extensions.swift
//  NaviyaLifeCareTest
//
//  Created by Aman gupta on 28/08/18.
//  Copyright © 2018 Aman Gupta. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UITableViewCell
extension UITableViewCell {
    
    //Reuse Identifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    //Get UINib Instance
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}
