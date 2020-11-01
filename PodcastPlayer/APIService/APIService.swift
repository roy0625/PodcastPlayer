//
//  APIService.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/31.
//

import Foundation

enum Result {
    case success(Data)
    case failure(Error)
}

class APIService {
    static func get(urlString: String, completion: @escaping (Result) -> Void) {
        guard let url = URL(string: urlString) else {
            let result = Result.failure(NSError() as Error)
            completion(result)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { responseData, response, responseError in
            if let error = responseError {
                completion(.failure(error))
            } else if let xmlData = responseData {
                let result = Result.success(xmlData)
                completion(result)
            }
        }
        task.resume()
    }
}

