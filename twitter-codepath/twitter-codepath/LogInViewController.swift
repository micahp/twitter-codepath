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
        TwitterClient.sharedInstance.login(success: { 
            print("I have logged in")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }) { (error) in
            print("error: \(error.localizedDescription)")
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
