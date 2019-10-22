//
//  UserController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/6/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class UserController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backHandler))
        applyFirstOutlet.layer.cornerRadius = 10
        applySecondOutlet.layer.cornerRadius = 10
        navigationItem.title = "User Account"
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference().child("users").child(uid)

        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
            self.usernameLabel.text = dictionary["Username"] as? String
            }
        }, withCancel: nil)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                self.emailLabel.text = dictionary["Email"] as? String
            }
        }, withCancel: nil)
        
    }
    
    func backHandler()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var newUsernameTextFiled: UITextField!
    
    @IBOutlet weak var applyFirstOutlet: UIButton!

    @IBOutlet weak var oldPasswordTextField: UITextField!

    @IBOutlet weak var newPasswordTextField: UITextField!

    @IBOutlet weak var applySecondOutlet: UIButton!
    
    @IBAction func applyFirstAction(_ sender: UIButton)
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let username = newUsernameTextFiled.text else {return}
        if !username.isEmpty{
       let ref = FIRDatabase.database().reference().child("users").child(uid)
        let values = ["Username":username]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil
            {
            print(error!)
                print(error!)
                handleErrors(err: error! as NSError)
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.usernameLabel.text = username
            let alert = UIAlertController(title: "Success", message: "Your Username has been successfully changed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.newUsernameTextFiled.text = ""
            }
        }
        else
        {
        let alert = UIAlertController(title: "Whops!", message: "Type in your new Username first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func applySecondAction(_ sender: UIButton)
    {
        guard let oldPass = oldPasswordTextField.text, let newPass = newPasswordTextField.text,let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
     let ref = FIRDatabase.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                if dictionary["Password"] as? String == oldPass
                {
                    FIRAuth.auth()?.currentUser?.updatePassword(newPass, completion: { (error) in
                        if error != nil {
                            print(error!)
                            handleErrors(err: error! as NSError)
                            let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return}
                        let alert = UIAlertController(title: "Success", message: "Your Password has been successfully changed", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                       let values = ["Password":newPass]
                        ref.updateChildValues(values)
                        self.oldPasswordTextField.text = ""
                        self.newPasswordTextField.text = ""
                    })
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: "Make sure your Old Password field is filled correctly", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }, withCancel: nil)
        
        
       
    }
    
}


