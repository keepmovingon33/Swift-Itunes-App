//
//  CacheManager.swift
//  Practice_iTunesApp
//
//  Created by Sky on 9/18/19.
//  Copyright © 2019 Sky. All rights reserved.
//

import Foundation

typealias DataHandler = (Data?) -> Void
let cache = CacheManager.shared

final class CacheManager {
    private let cache = NSCache<NSString, NSData>()
    
    static let shared = CacheManager()
    private init() {}
    
    func downloadForm(endpoint: String, completion: @escaping DataHandler) {
        
        //1. Check if the cache has the data
        if let data = cache.object(forKey: endpoint as NSString) {
            completion(data as Data)
//            print("Retrieved From Cache")
            return
        }
        
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        //2. If not, create Api Request
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            if let error = err {
                print("Bad Task: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = dat {
                
                //3. Save data in cache for next time
                self.cache.setObject(data as NSData, forKey: endpoint as NSString)
                
                //4. pass back data through the completion
                DispatchQueue.main.async {
                    //back to main thread to pass completion
                    completion(data)
//                    print("Make API request")
                }
    
            }
        }.resume()
    }
}
