//
//  User.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/20/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit

class User: NSObject {
    var name:String?
    var screen_name:String?
    var profile_image_url:URL?
    var tag_line:String?
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = "userDidLogout"
    
    init(dictionary:NSDictionary) {
        name = dictionary["name"] as? String
        screen_name = dictionary["screen_name"] as? String
        self.dictionary = dictionary
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let profileURLString = profileURLString {
            let profileURL = URL(string: profileURLString)
            profile_image_url = profileURL
        }
        
        tag_line = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData {
                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData, options: [])
                    
                    _currentUser = User(dictionary: dictionary as! NSDictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                    defaults.set(data, forKey: "currentUserData")
                    defaults.synchronize()
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
        }
    }
}
