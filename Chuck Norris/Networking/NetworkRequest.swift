//
//  NetworkRequest.swift
//  Chuck Norris
//
//  Created by Tanel Teemusk on 22/10/2018.
//  Copyright © 2018 Tanel Teemusk. All rights reserved.
//

import UIKit

enum JokeRequest: String {
    case categories = "https://api.chucknorris.io/jokes/categories"
    case joke = "https://api.chucknorris.io/jokes/random"
}

class NetworkRequest: NSObject {
    
    
    class func get(with request: JokeRequest, params: [String: String]? = nil, completion: @escaping (Data?, Error?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            var urlString = request.rawValue
            if let params = params {
                urlString += "?"
                params.forEach {
                    urlString += "\($0.key)=\($0.value)&"
                }
            }
            print("Request: \(urlString)")
            guard let url: URL = URL(string: urlString) else { return }
            var request = URLRequest(url: url)
            
            let session = URLSession.shared

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            let task = session.dataTask(with: request) { data, response, error in
                //print("Response: \(response)")
                DispatchQueue.main.async {
                    completion(data, error)
                }
            }
            task.resume()
        }
    }
}
