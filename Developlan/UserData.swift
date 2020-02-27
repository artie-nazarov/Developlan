//
//  UserData.swift
//  Developlan
//
//  Created by Artem Nazarov on 4/28/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit
import Firebase

class ProjectData: NSObject {
    
    var projectName:String?
    var languageChoosen:String?
    
}

class Task: NSObject
{

    var taskName:String?
    var taskDescription:String?
    
    var deadline:String?
    var taskFinished:String?

}

class ProgramingLanguages
{
    var languageName:String
    var languageImage:UIImage 
    
    init(languageName:String,languageImage:UIImage) {
        self.languageName = languageName
        self.languageImage = languageImage
    }
}

let programmingLanguagesArray: [ProgramingLanguages] =
    [ ProgramingLanguages(languageName: "C", languageImage: UIImage(named:"c")!),
      ProgramingLanguages(languageName: "Java", languageImage: UIImage(named:"java")!),
      ProgramingLanguages(languageName: "JavaScript", languageImage: UIImage(named:"javaScript")!),
      ProgramingLanguages(languageName: "HTML", languageImage: UIImage(named:"html")!),
      ProgramingLanguages(languageName: "C++", languageImage: UIImage(named:"c++")!),
      ProgramingLanguages(languageName: "Ruby", languageImage: UIImage(named:"ruby")!),
      ProgramingLanguages(languageName: "C#", languageImage: UIImage(named:"c#")!),
      ProgramingLanguages(languageName: "CSS", languageImage: UIImage(named:"css")!),
      ProgramingLanguages(languageName: "VB.net", languageImage: UIImage(named:"vb.net")!),
      ProgramingLanguages(languageName: "Python", languageImage: UIImage(named:"python")!),
      ProgramingLanguages(languageName: "PHP", languageImage: UIImage(named:"php")!),
      ProgramingLanguages(languageName: "Linux Scripting", languageImage: UIImage(named:"linuxScripting")!),
      ProgramingLanguages(languageName: "Assembly", languageImage: UIImage(named:"assembly")!),
      ProgramingLanguages(languageName: "JQuery", languageImage: UIImage(named:"jquery")!),
      ProgramingLanguages(languageName: "ASP.NET", languageImage: UIImage(named:"asp.net")!),
      ProgramingLanguages(languageName: "R", languageImage: UIImage(named:"r")!),
      ProgramingLanguages(languageName: "Other", languageImage: UIImage(named:"other")!)
  ]

var projectsArray = [ProjectData]()

var inProgressArray = [Task]()
var finishedArray = [Task]()

struct LoginErrorCode {
    let INVALID_EMAIL = "Invalid Email Address, Please Provide A Real Email Address"
    let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    let PROBLEM_CONNECTING = "Problem Connecting To Database, Please Try Later"
    let USER_NOT_FOUND = "User Not Found, Please Register"
    let EMAIL_ALREADY_IN_USE = "Email Already In Use, Please Use Another Email"
    let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long"
}

func reloadTableVeiw(_ tableView:UITableView)
{
    DispatchQueue.main.async {
        tableView.reloadData()
    }
}

let tutorialPicsArray = ["1","2","3","4","5","6","7","8","9"]

var errorString = ""

func handleErrors(err: NSError) {
    
    if let errCode = FIRAuthErrorCode(rawValue: err.code) {
        let loginError = LoginErrorCode()
        switch errCode {
            
        case .errorCodeWrongPassword:
            errorString = loginError.WRONG_PASSWORD
            
            
        case .errorCodeInvalidEmail:
            errorString = loginError.INVALID_EMAIL
            
            
        case .errorCodeUserNotFound:
            errorString = loginError.USER_NOT_FOUND
            
        case .errorCodeEmailAlreadyInUse:
            errorString = loginError.EMAIL_ALREADY_IN_USE
            
        case .errorCodeWeakPassword:
            errorString = loginError.WEAK_PASSWORD
            
            
        default:
            errorString = loginError.PROBLEM_CONNECTING
            
        }
        
    }
    
}

extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}



