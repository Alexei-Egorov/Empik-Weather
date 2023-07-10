//
//  ViewController.swift
//  Empik Weather
//
//  Created by Alexei Egorov on 10/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var mainVCLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainVCLabel.textColor = R.color.primary()
    }


}

