//
//  Tweet.swift
//  twitter-codepath
//
//  Created by Micah Peoples on 2/20/17.
//  Copyright © 2017 micah. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var author:String?
    var text:String?
    var timestamp:Date?
    var retweetCount:Int = 0
    var favoritesCount:Int = 0
    
    init(dictionary:NSDictionary) {
        text = dictionary["text"] as? String
        let user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        author = user.name
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
    }
 
    class func TweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
