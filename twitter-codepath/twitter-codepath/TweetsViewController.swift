//
//  TweetsViewController.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/27/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        TwitterClient.sharedInstance.homeTimeline(success: { (tweets) in
            
            for tweet in tweets {
                print(tweet.text!)
                self.tweets.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (error) in
            print("error: \(error.localizedDescription)")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        
        let tweet = tweets[indexPath.row]
        cell.authorLabel.text = tweet.author
        cell.tweetTextLabel.text = tweet.text
        cell.authorHandleLabel.text = tweet.screenName
        cell.timestampLabel.text = tweet.timestamp
        cell.profileImageView.setImageWith((tweet.user?.profile_image_url)!)
        
        return cell
    }

    @IBAction func onLogoutButtonTapped(_ sender: Any) {
        TwitterClient.sharedInstance.logout()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
