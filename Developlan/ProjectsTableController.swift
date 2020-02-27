//
//  ProjectsTableController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/1/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

var projectIndex = 0

class ProjectsTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        projectsArray.removeAll()

   navigationItem.title = "Projects"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(mainMenuHandler))
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        FIRDatabase.database().reference().child("users").child(uid).child("projects").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
            let project = ProjectData()
                let arg1 = "languageChoosen"
                let arg2 = "projectName"
                project.projectName = dictionary[arg2] as? String
                project.languageChoosen = dictionary[arg1] as? String 
                projectsArray.append(project)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
               }

            }

        }, withCancel: nil)
}

    @objc func mainMenuHandler()
    {
    let prep = storyboard!.instantiateViewController(withIdentifier: "mainMenu")
        let vc = UINavigationController(rootViewController: prep)
        present(vc, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return projectsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProjectsTableViewCell
        
        let array = projectsArray[indexPath.row]
        cell.projectName.text = array.projectName
        cell.dateCreated.text = array.languageChoosen
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        projectIndex = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let rowAction = UITableViewRowAction(style: .default, title: "Delete") { (UITableViewRowAction, indexPath:IndexPath) in
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
            FIRDatabase.database().reference().child("users").child(uid).child("projects").child(projectsArray[indexPath.row].projectName!).removeValue(completionBlock: { (error, ref) in
                if error != nil {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                projectsArray.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
           
           
        }
        return [rowAction]
    }
}
