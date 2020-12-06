//
//  APIClient.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/06.
//

/** 普通はこのようにURLSessionのラッパークラスを作る or ラッパーのOSSライブラリを使用するが今回は簡単化のためViewControllerに直接実装する
 
import Foundation

class APIClient {
    enum Result {
        case success(Data)
        case error(Error)
    }
    
    static let shared = APIClient()
    
    private init() {
        
    }
    
    func execute(_ request: URLRequest, completion: ((Result) -> Void)?) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { (data, response, error) in
            
        }
    }
}
**/
