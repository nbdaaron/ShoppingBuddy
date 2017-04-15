//
//  HomeViewController.swift
//  ShoppingBuddy
//
//  Created by Aaron Kau on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func find(_ sender: Any) {
        if spinner.isAnimating {
            spinner.stopAnimating()
            self.performSegue(withIdentifier: "buddyFound", sender: nil)
            
        } else {
            spinner.startAnimating()
            
        }
        
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
