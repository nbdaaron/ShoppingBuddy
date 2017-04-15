//
//  RegistrationViewController.swift
//  ShoppingBuddy
//
//  Created by Aaron Kau on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var user: FIRUser!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var age: UITextField!
    
    @IBAction func register(_ sender: Any) {
        
        if (name.text?.isEmpty)! || (gender.text?.isEmpty)! || (age.text?.isEmpty)! {
            return
        }
        ref.child("users").child(user.uid).setValue(["name": name.text!, "gender": gender.text!, "age": age.text!])
        self.performSegue(withIdentifier: "registerToHome", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        user = FIRAuth.auth()?.currentUser
        
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
