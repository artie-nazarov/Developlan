//
//  LoginRegisterController.swift
//  Developlan
//
//  Created by Artem Nazarov on 4/26/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.isHidden = true
        loginButtonProperty.layer.cornerRadius = 10
        usernameTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextfield.resignFirstResponder()
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        return true
    }
    
    @IBOutlet weak var segmentControllerOutlet: UISegmentedControl!
    
    
    @IBAction func segmentIndexChange(_ sender: UISegmentedControl)
    {
        switch segmentControllerOutlet.selectedSegmentIndex
        {
        case 0 : loginButtonProperty.setTitle("Login", for: .normal)
        usernameTextfield.isHidden = true
        emailTextfield.text = ""
        passwordTextfield.text = ""
        usernameTextfield.text = ""
        case 1 : loginButtonProperty.setTitle("Register", for: .normal)
        usernameTextfield.isHidden = false
        emailTextfield.text = ""
        passwordTextfield.text = ""
        usernameTextfield.text = ""
        default : break
        }
    }
    
    
   
    
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButtonProperty: UIButton!
    
    
    @IBAction func loginRegisterHandler(_ sender: UIButton)
    {
        if segmentControllerOutlet.selectedSegmentIndex == 0
        {
            guard let email = emailTextfield.text, let password = passwordTextfield.text else
            {
                print("No aplicable form avialable")
                return
            }
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                if error != nil
                {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        }
        else
        {
            guard let name = usernameTextfield.text, let email = emailTextfield.text, let password = passwordTextfield.text else
            {
                print("No aplicable form avialable")
                return
            }
            if !name.isEmpty {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                
                if error != nil
                {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let uid = user?.uid else
                {
                    return
                }
                
                let ref = FIRDatabase.database().reference(fromURL: "https://developlan-d2aaf.firebaseio.com/")
                let userReference = ref.child("users").child(uid)
                let values = ["Username":name,"Email":email,"Password":password]
                userReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
                    if error != nil
                    {
                        print(err!)
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                })
            })
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Please provide a Username", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
}
