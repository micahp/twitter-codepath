//
//  AppDelegate.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/20/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.description)
        
        // initialize twitter client
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "iHi8S8soxgOXCTrepMNjGCfOt", consumerSecret: "RkkEZK5mgcGohyjzTDFMghD55spnqeN2egZxDESklGe0ptuJBO")!
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        
        // Get access token using request token
        twitterClient.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            print("got access token!")
            
            // Get user information
            twitterClient.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let user = response as! NSDictionary
                print ("name: \(user["name"]!)")
            }, failure: { (task: URLSessionDataTask?, error) in
                print ("error: \(error.localizedDescription)")
            })
            
            // Get tweets from home feed
            twitterClient.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                let tweets = response as! [NSDictionary]
                for tweet in tweets {
                    print (tweet)
                    print ()
                }
                
            }, failure: { (task: URLSessionDataTask?, error) in
                print("error: \(error.localizedDescription)")
            })
            
        }) { (error) in
            print("error: \(error!.localizedDescription)")
        }
        
        
        
        
        return true
    }

}

