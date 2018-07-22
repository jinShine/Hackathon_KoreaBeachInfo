//
//  RegionViewController.swift
//  KoreaBeachInfo
//
//  Created by 김승진 on 2018. 7. 20..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "떠나요!"
    }
    
    @IBAction func goMapView(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let beachMapVC = storyboard.instantiateViewController(withIdentifier: "BeachMapVC")
        
        let deleveryName = beachMapVC as! BeachMapViewController
        deleveryName.regionName = sender.currentTitle!
        
        self.navigationController?.pushViewController(beachMapVC, animated: true)
    }
    

}
