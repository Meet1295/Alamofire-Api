//
//  AlamofireAPICall.swift
//  AlamofireAPIs
//
//  Created by Admin on 3/7/19.
//  Copyright © 2019 charts. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireAPICall: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //USING ALAMOFIRE
    func authAPI(username : String , password : String) {
        let mainURL = "\(kBaseURL)\(kAuth)"
        var params = [String:String]()
        params[kUserName] = kTokenAuthUserName
        params[kPassword] = kTokenAuthPassword
        
        Alamofire.request(mainURL, method: .post, parameters: params).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print(String(describing: response.result.error))
                return
            }
            
            if let authToken = response.result.value as? [String : AnyObject] {
                print(authToken)
                UserDefaults.standard.set(authToken["token"], forKey: "auth_token")
                self.sendverificationmailAPI(authToken: authToken["token"] as Any)
            }
        }
    }
    
    func sendverificationmailAPI(authToken : Any) {
        let mainURL = "\(kBaseURL)send-verification-mail/"
        var params = [String:String]()
        params[kEmail] = kTokenAuthUserName
        
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "JWT \(authToken)"
        
        Alamofire.request(mainURL, method : .post, parameters : params, encoding : JSONEncoding.default , headers : headers).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print(String(describing: response.result.error))
                return
            }
            
            if let authToken = response.result.value as? [String : AnyObject] {
                print(authToken)
            }
        }
    }
    
    func attendeeEventsAPI(authToken : Any) {
        let mainURL = "\(kBaseURL)attendee-events/current/"
        var headers: HTTPHeaders = [:]
        headers["Authorization"] = "JWT \(authToken)"
        
        Alamofire.request(mainURL, method : .get, parameters : [:], encoding : JSONEncoding.default , headers : headers).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print(String(describing: response.result.error))
                return
            }
            
            if let authToken = response.result.value as? [String : AnyObject] {
                print(authToken)
            }
        }
    }

}
