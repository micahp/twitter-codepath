//
//  TwitterClient.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/27/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
        
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "iHi8S8soxgOXCTrepMNjGCfOt", consumerSecret: "RkkEZK5mgcGohyjzTDFMghD55spnqeN2egZxDESklGe0ptuJBO")!
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "iHi8S8soxgOXCTrepMNjGCfOt", consumerSecret: "RkkEZK5mgcGohyjzTDFMghD55spnqeN2egZxDESklGe0ptuJBO")
        
        twitterClient!.deauthorize()
        twitterClient!.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter-codepath://oauth"), scope: nil, success: { (requestToken) in
            print("We got a token. Here it is: \(requestToken!.token!)")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url)
        }) { (error) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func retweet(tweet:Tweet) {
        TwitterClient.sharedInstance.post("https://api.twitter.com/1.1/statuses/retweet/\(tweet.id!).json", parameters: nil, progress: { (progress) in
            print("retweet in progress")
        }, success: { (task, result) in
            tweet.retweetCount += 1
            print("retweeted tweet id \(tweet.id)")
        }) { (task, error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func favorite(tweet:Tweet) {
        TwitterClient.sharedInstance.post("https://api.twitter.com/1.1/favorites/create.json", parameters: ["id":tweet.id!], progress: { (progress) in
            print("favorite in progress")
        }, success: { (task, result) in
            tweet.favoritesCount += 1
            print("favorited tweet id \(tweet.id)")
        }) { (task, error) in
            print("error: \(error.localizedDescription)")
        }
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)!

        // Get access token using request token
       TwitterClient.sharedInstance.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            print("got access token!")
        
            TwitterClient.sharedInstance.currentAccount(success: { (user) in
                User.currentUser = user
                self.loginSuccess?()
            
                print ("name: \(user.name)!")
                print ("screenname: \(user.screen_name)!")
                print ("profile url: \(user.profile_image_url)!")
                print ("description: \(user.tag_line)!")
            }, failure: { (error) in
                print ("error: \(error.localizedDescription)")
            })
        
            }) { (error) in
                print("error: \(error!.localizedDescription)")
                self.loginFailure?(error!)
            }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        // Get user information
       get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let user_dictionary = response as! NSDictionary
            
            let user = User(dictionary: user_dictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error) in
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) ->(), failure: @escaping (Error) -> ()) {
        // Get tweets from home feed
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.TweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error) in
            failure(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
}
