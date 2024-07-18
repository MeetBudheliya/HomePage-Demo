//
//  APIHelper.swift
//  HomePage Demo
//
//  Created by Nitin Paladiya on 18/07/24.
//

import Foundation

struct APIHelper{
    
    static let shared = APIHelper()
    
    func fetchPhotos(completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        guard let url = URL(string: "\(base_url)images/search?limit=50") else{
            return
        }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server response"])
                completion(nil, error)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP error \(httpResponse.statusCode)"])
                completion(nil, error)
                return
            }
            
            guard let responseData = data else {
                let error = NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, error)
                return
            }
            
            // Parse JSON data
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                    // Call completion handler with parsed data
                    completion(jsonArray, nil)
                } else {
                    let error = NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON"])
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
