//
//  InfoPopUpViewController.swift
//  KoreaBeachInfo
//
//  Created by 김승진 on 2018. 7. 20..
//  Copyright © 2018년 김승진. All rights reserved.
//

import UIKit
import SafariServices

class InfoPopUpViewController: UIViewController {
    
    
    @IBOutlet weak var beachTitle: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var beachWidth: UILabel!
    @IBOutlet weak var beachLength: UILabel!
    @IBOutlet weak var linkAddress: UILabel!
    @IBOutlet weak var linkTel: UILabel!
    
    var selectedData: [BeachInfo.ItemInfo.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let staName = selectedData[0].staName,
            let sidoName = selectedData[0].sidoName,
            let gugunName = selectedData[0].gugunName,
            let beachWidtd = selectedData[0].beachWidtd,
            let beachLength = selectedData[0].beachLength,
            let linkAddr = selectedData[0].linkAddr,
            let linkTel = selectedData[0].linkTel
        {
            self.beachTitle.text = "\(staName) 해수욕장"
            self.address.text = "\(sidoName) \(gugunName)"
            self.beachWidth.text = "\(Int(beachWidtd))M"
            self.beachLength.text = "\(Int(beachLength))M"
            self.linkAddress.text = linkAddr
            self.linkTel.text = linkTel
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

