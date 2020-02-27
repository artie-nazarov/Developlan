//
//  InProgTaskDetalController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/3/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class InProgTaskDetailController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButtonOutlet.layer.cornerRadius = 10
        taskNameLabel.text = inProgressArray[inProgressTaskIndex].taskName
        taskDescriptionTextView.text = inProgressArray[inProgressTaskIndex].taskDescription
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backHandler))
        taskDescriptionTextView.layer.cornerRadius = 10
    let deadlineString = inProgressArray[inProgressTaskIndex].deadline!
      //  deadlineString = String(deadlineString.characters.dropLast(15))
        let formatedString = DateFormatter()
        formatedString.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dateObj = formatedString.date(from: deadlineString)
        formatedString.dateFormat =  "EEE, dd MMM yyyy"
        let dateString = formatedString.string(from: dateObj!)
        deadlineLabel.text = dateString
        
    }
    
    
    func backHandler()
    {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    @IBOutlet weak var finishButtonOutlet: UIButton!
    
    @IBOutlet weak var deadlineLabel: UILabel!
    
    
    @IBAction func finishTaskAction(_ sender: UIButton)
    {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress").child(inProgressArray[inProgressTaskIndex].taskName!).removeValue { (error, ref) in
            if error != nil {
                print(error!)
                handleErrors(err: error! as NSError)
                let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return}
            
          let ref = FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("finished").child(inProgressArray[inProgressTaskIndex].taskName!)
            let values = ["taskDescription":inProgressArray[inProgressTaskIndex].taskDescription!,"taskName":inProgressArray[inProgressTaskIndex].taskName!,"taskFinished":inProgressArray[inProgressTaskIndex].taskFinished!]
            ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {return}
                
            })
            inProgressArray.remove(at: inProgressTaskIndex)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
   
    
    
}
