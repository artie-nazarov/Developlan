//
//  UserMenuController.swift
//  Developlan
//
//  Created by Artem Nazarov on 4/26/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class UserMenuController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandler))
        navigationItem.title = "Main menu"
        checkIfLogedIn()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateUsername()
        
    }
    
    
    func checkIfLogedIn()
    {
        if FIRAuth.auth()?.currentUser?.uid == nil
        {
            perform(#selector(logoutHandler), with: nil, afterDelay: 0)
        }
        else
        {
            updateUsername()
        }
    }
    
    
    func updateUsername()
    {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                self.userNameLabel.text = dictionary["Username"] as? String
            }
        }, withCancel: nil)
    }
    
    func logoutHandler()
    {
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError {
            print(logoutError)
        }
        let vc = storyboard!.instantiateViewController(withIdentifier: "loginScreen")
        present(vc, animated: true, completion: nil)
    }
    @IBAction func newProjectAction(_ sender: UIButton)
    {
        let prep = storyboard!.instantiateViewController(withIdentifier: "newProject") as! NewProjectController
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func openProjectAction(_ sender: UIButton)
    {
        let prep = storyboard!.instantiateViewController(withIdentifier: "projects")
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func userProfileButtonAction(_ sender: UIButton)
    {
        let prep = storyboard!.instantiateViewController(withIdentifier: "userProfile")
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    
    
}
