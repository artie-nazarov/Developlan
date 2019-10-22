//
//  FinishedTaskDetailController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/5/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit

class FinishedTaskDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDescriptionTextView.layer.cornerRadius = 10

        taskNameLabel.text = finishedArray[finishedTaskIndex].taskName
        taskDescriptionTextView.text = finishedArray[finishedTaskIndex].taskDescription
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backHandler))

    }

    func backHandler()
    {
    self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionTextView: UITextView!

}
