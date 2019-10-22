//
//  FinishedTableController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/5/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

var finishedTaskIndex = 0

class FinishedTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
finishedArray.removeAll()
      fetchTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        let bgImage = UIImage(named: "ViewBG")
        let finalImage = UIImageView(image: bgImage)
        self.tableView.backgroundView = finalImage
        
        finalImage.contentMode = .scaleAspectFill
        fetchTasks()
    }
    
    
    func fetchTasks()
    {
        var allowAppending = true
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("finished").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]
            {
                let task = Task()
                task.setValuesForKeys(dictionary)
                
                for i in finishedArray
                {
                    if i.taskName == task.taskName {allowAppending = false}
                }
                if allowAppending
                {
                    finishedArray.append(task)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishedArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FinishedTableCell
        
        let array = finishedArray[indexPath.row]
        
        cell.taskNameLabel.text = array.taskName
        
        if array.taskFinished == "0"
        {
            cell.statusImage.image = UIImage(named: "Ok-96")
        }
        else
        {
            cell.statusImage.image = UIImage(named: "Cancel-96")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finishedTaskIndex = indexPath.row
        let prep = storyboard!.instantiateViewController(withIdentifier: "finishedDetail")
        let vc = UINavigationController(rootViewController: prep)
        self.present(vc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, indexPath) in
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
            FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[projectIndex].projectName!).child("finished").child(finishedArray[indexPath.row].taskName!).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return}
                finishedArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
                return [deleteAction]
    }
}

