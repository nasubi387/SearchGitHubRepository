//
//  NSObject+className.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/05.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}
