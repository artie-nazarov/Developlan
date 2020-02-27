//
//  NewProjectController.swift
//  Developlan
//
//  Created by Artem Nazarov on 4/27/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class NewProjectController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate
{
    
    var localProjArray = [String]()
    
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    @IBOutlet weak var langsCollectionView: UICollectionView!
    
    @IBOutlet weak var otherLangTextField: UITextField!
    
    @IBOutlet weak var createProjectOutler: UIButton!
    
    @IBOutlet weak var langChoosenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.langsCollectionView.delegate = self
        self.langsCollectionView.dataSource = self
        createProjectOutler.layer.cornerRadius = 10
        langsCollectionView.backgroundView = nil
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancle", style: .plain, target: self, action: #selector(cancleHandler))
        navigationItem.title = "New Project"
        otherLangTextField.isHidden = true
        createProjectOutler.isHidden = true
        
        projectNameTextField.delegate = self
        otherLangTextField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        projectNameTextField.resignFirstResponder()
        otherLangTextField.resignFirstResponder()
        return true
    }
    
    func cancleHandler()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return programmingLanguagesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "languages", for: indexPath) as! LanguageCollectionViewCell
        let array = programmingLanguagesArray[indexPath.row]
        
        cell.langNameLabel.text = array.languageName
        cell.langImage.image = array.languageImage
        return cell
    }
    
    var progLangName = ""
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        progLangName = programmingLanguagesArray[indexPath.row].languageName
        if progLangName != "Other"{
            langChoosenLabel.text = "Your language : \(programmingLanguagesArray[indexPath.row].languageName)"
            otherLangTextField.isHidden = true
            createProjectOutler.isHidden = false
            
        }
        else
        {
            langChoosenLabel.text = "Type in your language"
            otherLangTextField.isHidden = false
            createProjectOutler.isHidden = false
            
        }
    }
    
    @IBAction func createProjectButton(_ sender: UIButton)
        
    {
        var allowGoing = true
        var nameTaken = false

        guard let projName = projectNameTextField.text, let otherLang = otherLangTextField.text, let uid = FIRAuth.auth()?.currentUser?.uid else
        {
            return
        }
        let ref = FIRDatabase.database().reference().child("users").child(uid).child("projects")
        
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if !projName.isEmpty && snapshot.hasChild(projName)
            {
               nameTaken = true
                print(nameTaken)
            }
        }, withCancel: nil)
        
        print(nameTaken)
        var langChoosen = ""
        if progLangName != "Other"
        {
            langChoosen = progLangName
        }
        else
        {
            langChoosen = otherLang
        }
        for lit in projName.characters
        {
            switch lit {
            case ".": allowGoing = false
            case "#": allowGoing = false
            case "$": allowGoing = false
            case "[":allowGoing = false
            case "]" : allowGoing = false
            default:
                break
            }
        }
        
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
     
        if !projName.isEmpty && allowGoing && !nameTaken{
            
            
            let values = ["projectName": projName,"languageChoosen":langChoosen]
            
            
            ref.child(projName).updateChildValues(values) { (error, ref) in
                if error != nil
                {
                    print(error!)
                    handleErrors(err: error! as NSError)
                    let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let prep = self.storyboard!.instantiateViewController(withIdentifier: "projects") as! ProjectsTableController
                let vc = UINavigationController(rootViewController: prep)
                self.present(vc, animated: true, completion: nil)
            }
        }
        else if nameTaken
        {
            let alert = UIAlertController(title: "Whops!", message: "You alredy have a project with such name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
            {
                let alert = UIAlertController(title: "Whops!", message: "Enter a proper project name. Make sure your name doesn't contain symbols: '.' '#' '$' '[' or ']'", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: nil))
                self.present(alert,animated: true, completion: nil)
            }
            
        }
  
    }
}
