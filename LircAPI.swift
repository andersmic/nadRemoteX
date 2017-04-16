//
//  LircAPI.swift
//  nadRemoteX
//
//  Created by Anders Michaelsen on 16/04/2017.
//  Copyright © 2017 Anders Michaelsen. All rights reserved.
//

import Foundation

class LircAPI {
    
    let host : String = "http://stue.local:9080/api"
    
    func queryPowerStatus(completionHandler: @escaping (Bool) -> Void) {
        NSLog("API: Query power status")
        
        let apiEndpoint: String = host + "/status"
        guard let url = URL(string: apiEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                print("error calling API")
                print(error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                // now we have the todo
                // let's just print it to prove we can access it
                //print("The status is: " + status.isEmpty)
                guard let status = json["status"] as? [String: Any] else {
                    print("Could not get status from JSON")
                    return
                }
                
                guard let powerStatus = status["power"] as? Bool else {
                    print("Could not get power status from JSON")
                    return
                }
                print("The power is: " + (powerStatus ? "On" : "Off"))
                completionHandler(powerStatus)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func sendCode(_ code : String, completionHandler: @escaping (Bool, Error?) -> Void) {
        NSLog("API: Sending command: %@", code)
        
        let apiEndpoint: String = host + "/send"
        guard let url = URL(string: apiEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 10
        
        let command: [String: Any] = ["code": code]
        let jsonCommand: Data
        do {
            jsonCommand = try JSONSerialization.data(withJSONObject: command, options: [])
            urlRequest.httpBody = jsonCommand
        } catch {
            print("Error: cannot create JSON from command")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                print("error calling API")
                print(error!)
                completionHandler(false, error)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                completionHandler(false, error)
                return
            }
            
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                
                let rc = self.parseReturnStatus(jsonResponse)
                print("The return code is: \(rc)")
                completionHandler(true, nil)
            } catch  {
                print("error trying to convert data to JSON")
                completionHandler(false, nil)
                return
            }
        }
        task.resume()
        
    }
    
    func parseReturnStatus(_ json : [String: Any]) -> Int {
        guard let rc = json["rc"] as? Int else {
            print("Could not get return code from JSON")
            return -1
        }
        return rc
    }
}
