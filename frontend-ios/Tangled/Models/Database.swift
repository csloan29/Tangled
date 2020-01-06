//
//  localDatabase.swift
//  Tangled
//
//  Created by Carter Sloan on 4/4/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import Alamofire
import SwiftyJSON

class Database: NSObject, CLLocationManagerDelegate {

  //singleton for database class to be shared across application
  //singleton has access to both local database and firestore database
  static let sharedDB : Database = Database()
  private override init() {
    super.init()
    
    //setup Firebase Auth
    
    //setup Firestore Database
    fsDB = Firestore.firestore()
    let settings = fsDB.settings
    settings.areTimestampsInSnapshotsEnabled = true
    fsDB.settings = settings
    
    //setup location manager
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  //DATABASE
  let matchServerURL: String = "54.218.121.232:3000"
  let locationManager = CLLocationManager()
  var matchArray : [Match] = []
  var fsDB: Firestore!
  var fsAuth: Auth!
  
  //GETTERS & SETTERS
  func getFirestoreDB() -> Firestore {
    return fsDB
  }
  
  func getMatches() -> [Match] {
    return matchArray
  }
  
  func getLocationManager() -> CLLocationManager {
    return locationManager
  }
  
  func updateLocationAndFetchMatchesFromDatabase() {
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //get the most specific value from the locations array
    let location = locations[locations.count - 1]
    //check to make sure the value returned is valid
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      
      //get user token
      let currentUser = Auth.auth().currentUser
      currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
        if let error = error {
          print(error)
          return;
        }
        let headers: HTTPHeaders = [
          "authorization": idToken!,
          "accept": "application/json"
        ]
        let parameters = [
          "longitude": location.coordinate.longitude,
          "latitude": location.coordinate.latitude,
        ]
        
        Alamofire.request("\(self.matchServerURL)/location/update", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
          print(response)
          //handle new matches here!
        }
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("ERROR: Location unavailable")
  }
  
}
