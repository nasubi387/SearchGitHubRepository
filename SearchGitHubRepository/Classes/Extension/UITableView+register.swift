//
//  UITableView+register.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/05.
//

import UIKit

extension UITableView {
    func register<CellType: UITableViewCell>(_ cellType: CellType.Type) {
        let nib = UINib(nibName: cellType.className, bundle: nil)
        register(nib, forCellReuseIdentifier: cellType.className)
    }
    
    func register(_ cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach { register($0) }
    }
}
