//
//  AutorizationViewController.swift
//  altarix3
//
//  Created by Mac on 2/28/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class AutorizationViewController: UIViewController {
    
    var admin = Autorization(login: "admin", password: "admin")
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTextField.text = "admin"
        passwordTextField.text = "admin"
    }

    @IBAction func acceptButton(_ sender: UIButton) {
        if admin.login == loginTextField.text && admin.password == passwordTextField.text {
            infoLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            infoLabel.text = "Успешно"
            performSegue(withIdentifier: "buttonToMainPage", sender: nil)
        } else {
            infoLabel.textColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
            infoLabel.text = "Ошибка вода"
        }
    }
}
