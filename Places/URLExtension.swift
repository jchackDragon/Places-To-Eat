//
//  URLExtension.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/21/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation

extension URL{
    
    var queryItems:[URLQueryItem]?{
        get{
            let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
            return urlComponents?.queryItems
        }
    }
}
