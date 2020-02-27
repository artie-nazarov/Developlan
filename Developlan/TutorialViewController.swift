//
//  TutorialViewController.swift
//  Developlan
//
//  Created by Artem Nazarov on 5/28/17.
//  Copyright © 2017 APPSkill. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        tutorialCollectionView.delegate = self
        tutorialCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialPicsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorial", for: indexPath) as! TutorialCollectionViewCell
        
        let pic = tutorialPicsArray[indexPath.row]
        
        cell.tutorialImage.image = UIImage(named: pic)
        return cell
    }
    
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    
       
        
        if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)) {
            print("bottom")
            arrowImage.image = UIImage(named: "Ok-96")
            UIView.animate(withDuration: 1.0) {
                self.arrowImage.alpha = 1.0
            }
            

        }
        
        if (scrollView.contentOffset.x < 0){
            arrowImage.image = UIImage(named:"off-sale-arrow-clipart-arrows-clip-art-navaho-native-american-clip-art-arrows-6273_3361")
            UIView.animate(withDuration: 1.0) {
                self.arrowImage.alpha = 1.0
            }

            
        }
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 1.0) {
            self.arrowImage.alpha = 0
        }

            }
    
    
}
