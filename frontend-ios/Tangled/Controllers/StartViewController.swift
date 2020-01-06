//
//  StartViewController.swift
//  Tangled
//
//  Created by Carter Sloan on 4/3/19.
//  Copyright © 2019 Carter Sloan. All rights reserved.
//

import Foundation
import UIKit

class StartViewController: UIViewController {
  
  @IBAction func goToLoginScreen(_ sender: Any) {
    self.performSegue(withIdentifier: "goToLogin", sender: self)
  }
  
  @IBAction func goToRegisterScreen(_ sender: Any) {
    self.performSegue(withIdentifier: "goToRegister", sender: self)
  }
  
}
