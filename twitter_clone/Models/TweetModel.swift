//
//  Tweet.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 13.01.2024.
//

import Foundation

struct TweetModel:Codable{
    var id = UUID().uuidString
    let author:TwitterUserModel
    let authorID:String
    let tweetContent:String
    var likesCount:Int
    var likers:[String]
    let isReply:Bool
    let parentReference:String?
    
}
