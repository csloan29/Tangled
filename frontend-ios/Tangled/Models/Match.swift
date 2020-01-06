//
//  Match.swift
//  Tangled
//
//  Created by Carter Sloan on 4/4/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

//EXPLANATION OF MATCH
//Matches are both potential matches and definite matches
//a potential match is someone you crossed paths with, but both parties have not decided to tangle
//a definite match is another user who you have decided to tangle with and that has done the same for you
//some values are not populated until you have definitely matched with another user

import Foundation

class Match {
  
  init(matched : Bool, region : String) {
    self.matched = matched
    self.region = region
  }
  
  //permanent parameters
  var matched : Bool
  var region: String
  
  //matched parameters
  var name : String?
  var chatList : [ChatItem]?
  
  
  //getters and setters for a match
  func hasMatched() -> Bool {
    return matched
  }
  
  func getRegion() -> String {
    return region
  }
  
  func getName() -> String? {
    return name
  }
  
  func getChatList() -> [ChatItem]? {
    return chatList
  }
  
  func addChatToList(text : String, owner : String) {
    let newChat = ChatItem(text: text, owner: owner)
    chatList?.append(newChat)
  }
}
