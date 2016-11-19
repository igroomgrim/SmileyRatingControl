//
//  ViewController.swift
//  Smiley
//
//  Created by Anak Mirasing on 11/19/2559 BE.
//  Copyright © 2559 iGROOMGRiM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let ratingControl = SMLRatingControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showButtonTapped(_ sender: Any) {
        ratingControl.show()
    }

}

