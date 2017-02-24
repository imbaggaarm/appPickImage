//
//  API.swift
//  appECONVEETEMP
//
//  Created by Dung Duong on 1/3/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

let domain: String = "http://imbaggaarm.esy.es/"
enum API: String{
    
    case getCategory = "Category.php"
    case getPost = "postTemp%20copy.json"
    
    var fullLink: String{
        return domain + rawValue
    }
}
