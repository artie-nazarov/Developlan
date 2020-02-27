//
//  InProgressTableController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/3/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

var inProgressTaskIndex = 0

class InProgressTableController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       inProgressArray.removeAll()
        navigationItem.title = "In Progress Tasks"
        fetchTasks()
        dateChecker()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bgImage = UIImage(named: "ViewBG")
        let finalImage = UIImageView(image: bgImage)
        self.tableView.backgroundView = finalImage
        
        finalImage.contentMode = .scaleAspectFill
        
        fetchTasks()
        dateChecker()
            }
    
    func fetchTasks()
    {
        var allowAppending = true
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let task = Task()
                task.setValuesForKeys(dictionary)
                
                for i in inProgressArray
                {
                    if i.taskName == task.taskName {allowAppending = false}
                }
                if allowAppending
                {
                    inProgressArray.append(task)
                }
                
            }
        }, withCancel: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func dateChecker()
    {
        for index in 0..<inProgressArray.count{
            
            let str = inProgressArray[index].deadline!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            let dateObj = dateFormatter.date(from: str)
            
            if NSDate() >= dateObj! as NSDate
            {
                guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}

                let ref = FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress").child(inProgressArray[index].taskName!)
                ref.updateChildValues(["taskFinished":"1"])
                
                inProgressArray[index].taskFinished = "1"
                reloadTableVeiw(tableView)
            }
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateChecker()
        reloadTableVeiw(tableView)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inProgressArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InProgressTableCell
        
        let array = inProgressArray[indexPath.row]
        
        cell.taskName.text = array.taskName
        
        if array.taskFinished == "0"
        {
            cell.statusImage.image = UIImage(named: "Process-100")
        }
        else
        {
            cell.statusImage.image = UIImage(named: "Cancel-96")

        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inProgressTaskIndex = indexPath.row
        let prep = storyboard!.instantiateViewController(withIdentifier: "inProgDetail")
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, indexPath) in
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
            FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("inProgress").child(inProgressArray[indexPath.row].taskName!).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return}
                inProgressArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (UITableViewRowAction, indexPath:IndexPath) in
            let prep = self.storyboard!.instantiateViewController(withIdentifier: "editView")
            let vc = UINavigationController(rootViewController: prep)
            self.present(vc, animated: true, completion: nil)
            inProgressTaskIndex = indexPath.row
        }
        editAction.backgroundColor = UIColor.blue
        
        return [deleteAction,editAction]
    }
}
