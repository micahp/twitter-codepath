//
//  LogInViewController.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/20/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LogInViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapLoginButton(_ sender: Any) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "iHi8S8soxgOXCTrepMNjGCfOt", consumerSecret: "RkkEZK5mgcGohyjzTDFMghD55spnqeN2egZxDESklGe0ptuJBO")
        
        twitterClient!.deauthorize()
        twitterClient!.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitter-codepath://oauth"), scope: nil, success: { (requestToken) in
            print("We got a token. Here it is: \(requestToken!.token!)")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url)
        }) { (error) in
            print("error: \(error?.localizedDescription)")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
