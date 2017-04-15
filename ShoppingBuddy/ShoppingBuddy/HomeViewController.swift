//
//  HomeViewController.swift
//  ShoppingBuddy
//
//  Created by Aaron Kau on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var user: FIRUser!

    @IBAction func find(_ sender: Any) {
        if spinner.isAnimating {
            spinner.stopAnimating()
            FIRDatabase.database().reference().child("queue").child(user.uid).removeValue()
            
        } else {
            spinner.startAnimating()
            FIRDatabase.database().reference().child("queue").child(user.uid).setValue("1")
            FIRDatabase.database().reference().child("queue").observe(FIRDataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                postDict.forEach({ item in
                    let (key, value) = item
                    if key == self.user.uid {
                        return
                    } else if value as! String == "1" || value as! String == self.user.uid {
                        FIRDatabase.database().reference().child("users").child(self.user.uid).child("partner").setValue(key)
                        FIRDatabase.database().reference().child("queue").child(self.user.uid).setValue(key)
                        FIRDatabase.database().reference().child("queue").removeAllObservers()
                        self.performSegue(withIdentifier: "buddyFound", sender: nil)
                    }
                })
            })
        }
        
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FIRAuth.auth()?.currentUser
        spinner.hidesWhenStopped = true
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
