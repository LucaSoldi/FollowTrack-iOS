//
//  RestApi.swift
//  FollowTrack
//
//  Created by Luca Soldi on 09/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

public class RestApi {
    
    static let sharedInstance: RestApi = RestApi()
    
    
    //private let baseUrl = "mainfarm"
    //private let baseUrl = "http://127.0.0.1:8080"
    #if (arch(i386) || arch(x86_64)) && os(iOS)
    private let baseUrl = "http://127.0.0.1:8080"
    #else
    private let baseUrl = "http://172.20.10.3:8080"
    #endif
    private let loginPath = "pony/auth/"
    private let tokenPath = "getTokenTrack"
    private let inviteFriendPath = "inviteFriend"
    let keychain = KeychainSwift()
    
    
    public func getTokenTrack(completion: @escaping (Bool, String) -> Void) {
        Alamofire.request(baseUrl + "/" + tokenPath, method: .get, parameters: nil,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    completion(false, "");
                 //   print(response.result.error!)
                    return
                }
                guard let json = response.result.value as? [String: Any] else {
                   // print("Error: \(response.result.error)")
                    completion(false, "");
                    return
                }
                guard let token = json["token_track"] as? String else {
                    //print("Could not get token from JSON")
                    completion(false, "");
                    return
                }
              //  print("The token is: " + token)
                completion(true, token)
        }
        
    }
    
    public func inviteFriendByMail(email: String, tokenTrack: String, completion: @escaping (Bool) -> Void) {
        
        let reqParameters: [String: Any] = ["email": email, "token_track": tokenTrack]
        Alamofire.request(baseUrl + "/" + inviteFriendPath, method: .post, parameters: reqParameters,
                          encoding: JSONEncoding.default)
            .responseJSON { response in
                guard response.result.error == nil else {
                    completion(false);
                    //print(response.result.error!)
                    return
                }
                guard let json = response.result.value as? [String: Any] else {
                    //print("Error: \(response.result.error)")
                    completion(false);
                    return
                }
                guard let success = json["suceess"] as? Bool else {
                    //print("Could not get success from JSON")
                    completion(false);
                    return
                }
                
                if (success) {
                    completion(true)
                }
                else {
                    completion(false)
                }
        }
    }

}
