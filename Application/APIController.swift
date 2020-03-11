//
//  APIController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 4/16/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIController {
    
    private let baseUrl = URL(string: "https://lambdaanimalspotter.vapor.cloud/api")!
    
    var bearer: Bearer?
    
    // create function for sign up
    func signUp(with user: User, completion: @escaping (Error?) -> ()) {
        let signUpUrl = baseUrl.appendingPathComponent("users/signup")
        
        var request = URLRequest(url: signUpUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //just like the decoder but in reverse order - taking the swift object and encode it to JSON to POST to the API
        let jsonEncoder = JSONEncoder()
        do {
            // what you get back is a data object
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            //this is for a server level error:
            if let response = response  as? HTTPURLResponse,
                // some codes are general but sometimes these codes might be different depending on the backend developer - check with backend developer to see what status codes/responses are for what you're doing.
                response.statusCode != 200 {
                completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                return
            }
            
            // error in processesing the request itself e.g. no internet connection, timeout (waiting too long), etc. :
            if let error = error {
                // passing the error up to the UI:
                completion(error)
                return
            }
            
            // if nither of the above is true we need to signal to the UI:
            completion(nil)
        }.resume()
    }
    
    // create function for sign in
    func signIn(with user: User, completion: @escaping (Error?) -> ()) {
           let signInUrl = baseUrl.appendingPathComponent("users/login")
           
           var request = URLRequest(url: signInUrl)
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           //just like the decoder but in reverse order - taking the swift object and encode it to JSON to POST to the API
           let jsonEncoder = JSONEncoder()
           do {
               // what you get back is a data object
               let jsonData = try jsonEncoder.encode(user)
               request.httpBody = jsonData
           } catch {
               NSLog("Error encoding user object: \(error)")
               completion(error)
               return
           }
           
           URLSession.shared.dataTask(with: request) { data, response, error in
               //this is for a server level error:
               if let response = response  as? HTTPURLResponse,
                   // some codes are general but sometimes these codes might be different depending on the backend developer - check with backend developer to see what status codes/responses are for what you're doing.
                   response.statusCode != 200 {
                   completion(NSError(domain: response.description, code: response.statusCode, userInfo: nil))
                   return
               }
               
               // error in processesing the request itself e.g. no internet connection, timeout (waiting too long), etc. :
               if let error = error {
                   // passing the error up to the UI:
                   completion(error)
                   return
               }
            
            guard let data = data else {
                completion(NSError(domain: "Data not found", code: 99, userInfo: nil))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                //What info are we going to get back - check API documentation
                self.bearer = try decoder.decode(Bearer.self, from: data)
                completion(nil)
                
            } catch {
                NSLog("error decoding bearer object: \(error)")
                //bubble up that error to the user:
                completion(error)
                return
            }
           }.resume()
       }
    
    // create function for fetching all animal names
    
    // create function for fetching animal details
    
    // create function to fetch image
}
