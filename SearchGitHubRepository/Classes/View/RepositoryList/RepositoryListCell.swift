//
//  RepositoryListCell.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/05.
//

import UIKit

class RepositoryListCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel! {
        didSet {
            repositoryNameLabel.font = UIFont.systemFont(ofSize: 14)
            repositoryNameLabel.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(with repository: Repository) {
        repositoryNameLabel.text = repository.name
    }
    
}
