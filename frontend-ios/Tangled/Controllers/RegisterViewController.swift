//
//  RegisterViewController.swift
//  Tangled
//
//  Created by Carter Sloan on 4/3/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
  
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

  @IBOutlet weak var viewContainer: UIView!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  
  @IBAction func onRegisterSubmit(_ sender: Any) {
    
    if (passwordTextField.text != confirmPasswordTextField.text) {
      let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      return
    }
    
    guard let email = emailTextField.text, let password = passwordTextField.text else {
      let alertController = UIAlertController(title: "Missing Text", message: "Please fill in all fields", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
      return
    }
    
    self.performSegue(withIdentifier: "goToBioFromRegister", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "goToBioFromRegister") {
      let bioVC = segue.destination as! BioViewController
      bioVC.email = emailTextField.text!
      bioVC.password = passwordTextField.text!
    }
  }
  
}
