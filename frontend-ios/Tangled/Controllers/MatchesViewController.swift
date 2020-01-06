//
//  MatchesViewController.swift
//  Tangled
//
//  Created by Carter Sloan on 4/3/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import Foundation
import UIKit

class MatchesViewController: UIViewController {
  
  var localDB: Database?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    localDB = Database.sharedDB
    localDB?.getLocationManager().requestAlwaysAuthorization()
    localDB?.updateLocationAndFetchMatchesFromDatabase()
  }
  

}
