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
    var screenName:String?
    var user:User?
    var text:String?
    var timestamp:String?
    var retweetCount:Int = 0
    var favoritesCount:Int = 0
    
    init(dictionary:NSDictionary) {
        text = dictionary["text"] as? String
        let user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        self.user = user
        author = user.name
        screenName = user.screen_name
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        // Get annoying ass "3s" "4h" "1d" formatted date
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
            formatter.unitsStyle = .abbreviated
            formatter.maximumUnitCount = 1
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "EEE MM d HH:mm:ss Z y"
            let createdDate = formatter2.date(from: timestampString)
            if let createdDate = createdDate {
                let calendar = Calendar.current
                let nowDate = Date()
                let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
                let dateComponents = calendar.dateComponents(units, from: createdDate, to: nowDate)
                timestamp = formatter.string(from: dateComponents)
            }
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
