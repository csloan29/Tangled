//
//  LoginViewController.swift
//  Tangled
//
//  Created by Carter Sloan on 4/3/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

// Put this piece of code anywhere you like
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

class LoginViewController: UIViewController {
  
  @IBOutlet weak var viewContainer: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  @IBAction func onLoginSubmit(_ sender: Any) {
    
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      let alertController = UIAlertController(title: "Error", message: "Please enter a value for all fields", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      return
    }
    
    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
      if error == nil{
        self.performSegue(withIdentifier: "goToMatchesFromLogin", sender: self)
      }
      else{
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
}
