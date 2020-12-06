//
//  RepositoryListViewController.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/05.
//

import UIKit

class RepositoryListViewController: UIViewController {
    
    /// 取得したレポジトリのリスト。値を更新するとtableViewをリロードする。
    var repositories = [Repository]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    /// 通信中フラグ。通信状態によって各UIの表示状態を制御する。また、通信中はUI操作ができないようにsuper viewのユーザインタラクションフラグをfasleにする
    var isLoading: Bool = false {
        didSet {
            // 常にUI操作はメインスレッドで実行する
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.isHidden = self.isLoading
                self.indicator.isHidden = !self.isLoading
                self.isLoading ? self.indicator.startAnimating() : self.indicator.stopAnimating()
                self.view.isUserInteractionEnabled = !self.isLoading
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
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.style = .large
            indicator.isHidden = true
        }
    }
    
    // MARK:- LifeCycle
    
    /// 画面読込時処理
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 画面表示直前処理
    /// - Parameter animated: アニメーション有無
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        updateTitle(with: "Search GitHub Repository")
    }
    
    // MARK:- Action
    
    /// 画面タイトルを更新する
    /// - Parameter title: タイトル
    func updateTitle(with title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.title = title
        }
    }
    
    /// エラーアラートを表示する
    /// - Parameter message: エラーメッセージ
    func presentError(message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okButton)
            self?.present(alert, animated: true, completion: nil)
            self?.updateTitle(with: "Search GitHub Repository")
        }
    }
    
    // MARK:- API
    
    /// 検索API実行
    /// - Parameter keyword: 検索キーワード
    func fetchRepository(with keyword: String) {
        // 通信中の場合は処理を実行しない
        guard !isLoading else {
            return
        }
        isLoading = true
        // 前回の検索結果をクリア
        repositories = []
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
            
            // 通信処理完了後に通信フラグを戻す
            defer {
                self.isLoading = false
            }
            
            // エラーが発生した場合はエラー表示
            guard let data = data, error == nil else {
                if let message = error?.localizedDescription {
                    self.presentError(message: message)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                // レスポンスのJSONデータをレスポンス構造体にデコードし、表示するデータとしてrepositoriesに保持する
                let response = try decoder.decode(SearchRepositoryResponse.self, from: data)
                self.repositories = response.items
                // 検索キーワードを画面タイトルとする
                self.updateTitle(with: keyword)
            } catch let error {
                // デコードに失敗した場合はエラー表示（基本的にここには入らない想定。入った場合は不具合）
                self.presentError(message: error.localizedDescription)
            }
        }
        // API実行
        task.resume()
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    /// 表示セル数。取得したレポジトリの数分リストで表示する
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: section
    /// - Returns: セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    /// 表示セル設定。レポジトリの値でセルの内容を更新する
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    /// - Returns: 設定後のセル
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryListCell.className, for: indexPath)
        
        if let cell = cell as? RepositoryListCell {
            cell.setup(with: repositories[indexPath.row])
        }
        
        return cell
    }
}

extension RepositoryListViewController: UITableViewDelegate {
    /// セルタップ時処理。
    /// - Parameters:
    ///   - tableView: tableView
    ///   - indexPath: indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RepositoryListViewController: UISearchBarDelegate {
    /// 検索タップ時処理。キーワードがない場合エラー表示。正常な場合はAPIを実行する
    /// - Parameter searchBar: searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            presentError(message: "検索するキーワードを入力してください。")
            return
        }
        fetchRepository(with: keyword)
    }
}
