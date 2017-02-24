//
//  Method.swift
//  appECONVEETEMP
//
//  Created by Dung Duong on 1/3/17.
//  Copyright © 2017 Tai Duong. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String{
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case HEAD = "HEAD"
    var toString: String{
        return self.rawValue
    }
}
