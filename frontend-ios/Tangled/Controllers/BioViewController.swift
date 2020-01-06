//
//  BioController.swift
//  Tangled
//
//  Created by Carter Sloan on 4/9/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class BioViewController: UIViewController {
  
  var localDB = Database.sharedDB
  var fsDB: Firestore?
  
  var email: String?
  var password: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //initialize firebase db
    fsDB = localDB.getFirestoreDB()
    
    //hide keyboard with tap onscreen
    self.hideKeyboardWhenTappedAround()
    // corner radius
    viewContainer.layer.cornerRadius = 10
    // shadow
    viewContainer.layer.shadowColor = UIColor.gray.cgColor
    viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
    viewContainer.layer.shadowOpacity = 0.7
    viewContainer.layer.shadowRadius = 4.0
  }
  
  
  @IBOutlet weak var viewContainer: UIView!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var sexTextField: UITextField!
  @IBOutlet weak var orientationTextField: UITextField!
  
  
  @IBAction func onBioSubmit(_ sender: Any) {
    
    if (nameTextField.text == "" || sexTextField.text == "" || orientationTextField.text == "") {
      let alertController = UIAlertController(title: "Missing Text", message: "Please fill in all fields", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      return
    }
    
    //Register new user with Firebase
    guard let email = self.email, let password = self.password else {
      
      self.navigationController?.popViewController(animated: true)
      
      let message = "local database did not save user credentials. Please return and fill out your email and password again"
      let alertController = UIAlertController(title: "Database Error", message: message, preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
        self.popNavScreen()
      })
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      return
    }
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
      if error == nil {
        
        var data: [String:Any] = [
          "email": self.email,
          "name": self.nameTextField.text,
          "sex": self.sexTextField.text,
          "orientation": self.orientationTextField.text
        ]
        
        let uid = Auth.auth().currentUser!.uid
        self.fsDB?.collection("users").document(uid).setData(data) { err in
          if let err = err {
            print("Error adding document: \(err)")
          } else {
            self.performSegue(withIdentifier: "goToMatchesFromBio", sender: self)
          }
        }
      }
      else{

        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
          self.popNavScreen()
        })
    
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      }
    }
    
  }
  
  func popNavScreen() {
    self.navigationController?.popViewController(animated: true)
  }
  
  func addUserToFirebase() {
    
  }
  
}
