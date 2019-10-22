//
//  EditTaskController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/5/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class EditTaskController: UIViewController,UITextViewDelegate,UITextFieldDelegate {

    var startingName = ""
    var startingDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
textDescriptionTextView.layer.cornerRadius = 10
        taskNameTextField.text = inProgressArray[inProgressTaskIndex].taskName
        textDescriptionTextView.text = inProgressArray[inProgressTaskIndex].taskDescription

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancleHandler))
        taskNameTextField.delegate = self
        textDescriptionTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let name = taskNameTextField.text , let desc = textDescriptionTextView.text else {return}
        
        startingName = name
        startingDescription = desc
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func cancleHandler()
    {
        self.dismiss(animated: true, completion: nil)
    }
 
    @IBOutlet weak var taskNameTextField: UITextField!
    
    
    @IBOutlet weak var taskNameLabel: UILabel!

    @IBOutlet weak var textDescriptionTextView: UITextView!
    
    @IBOutlet weak var finishEditingOutlet: UIButton!

    @IBAction func finishEditingButtonAction(_ sender: UIButton)
    {
        guard let text = textDescriptionTextView.text,let name = taskNameTextField.text, let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress")
        
        var allowGoing = true
        var nameTaken = false
        for lit in name.characters
        {
            switch lit {
            case ".": allowGoing = false
            case "#": allowGoing = false
            case "$": allowGoing = false
            case "[": allowGoing = false
            case "]": allowGoing = false
            default : break
                
            }
        }
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !name.isEmpty && snapshot.hasChild(name)
            {
                nameTaken = true
                
            }
            if name == self.startingName
            {
                nameTaken = false
            }
        })
        
        let deadlineDate = inProgressArray[inProgressTaskIndex].deadline!
        let taskFinished = inProgressArray[inProgressTaskIndex].taskFinished!
        
     
    if !name.isEmpty && allowGoing && !nameTaken {
        let values = ["taskDescription":text,"taskName":name,"deadline":deadlineDate,"taskFinished":taskFinished]
        ref.child(name).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                handleErrors(err: error! as NSError)
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return}
            inProgressArray[inProgressTaskIndex].taskDescription = text
            if name == self.startingName
            {
            self.cancleHandler()
            }
        }
    
        
        if name != self.startingName {
        ref.child(inProgressArray[inProgressTaskIndex].taskName!).removeValue { (error, ref) in
            if error != nil {return}
          inProgressArray.remove(at: inProgressTaskIndex)
             self.cancleHandler()
        }
    }

}
        
       else if nameTaken
       {
        let alert = UIAlertController(title: "Whops!", message: "You alredy have a task with such name", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
       }
        
       else
       {
        let alert = UIAlertController(title: "Whops!", message: "Enter a proper task name. Make sure your name doesn't contain symbols: '.' '#' '$' '[' or ']'", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel
            , handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    
    }
}
