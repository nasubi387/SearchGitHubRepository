//
//  RepositoryListViewController.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/05.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(RepositoryListCell.self)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "検索"
        }
    }
    
    // MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateTitle(with: "Search GitHub Repository")
    }
    
    // MARK:- Action
    
    func updateTitle(with title: String) {
        navigationItem.title = title
    }
    
    // MARK:- API
    
    func fetchRepository(with keyword: String) {
        // セッション作成
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // クエリ作成
        var compnents = URLComponents(string: "https://api.github.com/search/repositories")!
        let param = URLQueryItem(name: "q", value: keyword)
        compnents.queryItems = [param]
        // リクエスト作成
        var request = URLRequest(url: compnents.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        // タスク作成 (※循環参照を回避するために[weak self]としている)
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            
            guard let data = data, error == nil else {
                // ToDo: Error Handling
                print(error?.localizedDescription ?? "")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(SearchRepositoryResponse.self, from: data)
                self.repositories = response.items
            } catch let error {
                print(error)
            }
        }
        // API実行
        task.resume()
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.className, for: indexPath)
        
        if let cell = cell as? RepositoryListCell {
            cell.setup(with: repositories[indexPath.row])
        }
        
        return cell
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RepositoryListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else {
            return
        }
        fetchRepository(with: keyword)
    }
}
