//
//  ChatItem.swift
//  Tangled
//
//  Created by Carter Sloan on 4/4/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import Foundation

class ChatItem {
  
  init(text: String, owner: String) {
    self.text = text
    self.owner = owner
  }
  
  var text : String
  var owner : String
  
  func getText() -> String {
    return text
  }
  
  func getOwner() -> String {
    return owner
  }
  
}
