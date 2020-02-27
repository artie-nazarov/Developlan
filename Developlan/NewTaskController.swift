//
//  NewTaskController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/3/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class NewTaskController: UIViewController,UITextFieldDelegate,UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        taskDescriptionTextView.layer.cornerRadius = 10
        
        createButtonOutlet.layer.cornerRadius = 10

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancleHandler))

        taskNameTextField.delegate = self
        taskDescriptionTextView.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskNameTextField.resignFirstResponder()
        return true
    }
    
    
    func cancleHandler()
    {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var daysToCompleteTextField: UITextField!
    

    @IBOutlet weak var taskNameTextField: UITextField!
    
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    @IBOutlet weak var createButtonOutlet: UIButton!
    
    @IBAction func createTaskAction(_ sender: UIButton)
    {
        var allowGoing = true
        var nameTaken = false
        var numberIsLegit = true
        let array =  projectsArray[projectIndex]
        guard let name = taskNameTextField.text,let description = taskDescriptionTextView.text,let daysText = daysToCompleteTextField.text, let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("projects").child(array.projectName!).child("inProgress")
        
        for char in daysText.characters
        {
            if char == "1" || char == "2" || char == "3" || char == "4" || char == "5" || char == "6" || char == "7" || char == "8" || char == "9" || char == "0"
            {
                // just no code
            }
            else
            {
                numberIsLegit = false
            }
        }
        
        var deadlineDate:String?
        
        if let number = Int(daysText)
        {
            var date = NSDate()
            for _ in 1...number
            {
                date = date + 1.days
            }
            deadlineDate = String(describing: date)
           
            if number > 999 && number < 1
            {
                numberIsLegit = false
            }
        
        }
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !name.isEmpty && snapshot.hasChild(name)
            {
                nameTaken = true
            }
        })
        
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
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
        if !name.isEmpty && allowGoing && !nameTaken && !daysText.isEmpty && numberIsLegit{
    
        let values = ["taskName":name,"taskDescription":description,"deadline":deadlineDate,"taskFinished":"0"]
        
        ref.child(name).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                handleErrors(err: error! as NSError)
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return}
            
            self.dismiss(animated: true, completion: nil)
        }
        }
        else if nameTaken
        {
            let alert = UIAlertController(title: "Whops!", message: "You alredy have a task with such name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
       

        else if !numberIsLegit || daysText.isEmpty
        {
            let alert = UIAlertController(title: "Whops!", message: "Enter a proper number of days (999 days is maximum)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

            
        else
            {
                let alert = UIAlertController(title: "Whops!", message: "Enter a proper task name. Make sure your name doesn't contain symbols: '.' '#' '$' '[' or ']'", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
                self.present(alert,animated: true, completion: nil)

            }
        }
    }
    
}
