//
//  HomeController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/2/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectName.text = projectsArray[projectIndex].projectName
        finishedArray.removeAll()
        inProgressArray.removeAll()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        // inProgressArray.removeAll()
        var allowInProg = true
        FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let task = Task()
                task.setValuesForKeys(dictionary)
                
                for i in inProgressArray
                {
                    if i.taskName == task.taskName {allowInProg = false}
                }
                if allowInProg
                {
                    inProgressArray.append(task)
                }
                
                
            }
        }, withCancel: nil)
        
                
        
        // finishedArray.removeAll()
        var allowFinished = true
        FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("finished").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let task = Task()
                task.setValuesForKeys(dictionary)
                
                for i in finishedArray
                {
                    if i.taskName == task.taskName {allowFinished = false}
                }
                if allowFinished
                {
                    finishedArray.append(task)
                }
                
            }
            
        }, withCancel: nil)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tasksInProjectLabel.text = "Tasks in progress : \(inProgressArray.count)"
        self.tasksFinishedLabel.text = "Tasks finished : \(finishedArray.count)"
        

    }
    
    @IBOutlet weak var projectName: UILabel!
    
    @IBOutlet weak var tasksInProjectLabel: UILabel!
    
    @IBOutlet weak var tasksFinishedLabel: UILabel!
    
    @IBAction func createNewTaskButton(_ sender: UIButton)
    {
        
        let prep = storyboard!.instantiateViewController(withIdentifier: "newTask")
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    
}
