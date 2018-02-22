//
//  LoginViewController.swift
//  SmartLock
//
//  Created by Matheus Vaccaro on 22/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var database: FakeDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.database = FakeDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLoginButton(_ sender: Any) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let user = database.verify(login: username, password: password)
        if user != nil {
            UserModel.shared.user = user
            performSegue(withIdentifier: "goToHomes", sender: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
