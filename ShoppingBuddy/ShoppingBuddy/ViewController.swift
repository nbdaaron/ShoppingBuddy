//
//  ViewController.swift
//  ShoppingBuddy
//
//  Created by Aaron Kau on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    @IBAction func hitLoginButton(_ sender: Any) {
        //GIDSignIn.sharedInstance().signIn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        FIRAuth.auth()?.addStateDidChangeListener() {
            auth, user in
            if (user != nil) {
                FIRDatabase.database().reference().child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    if value != nil {
                        self.performSegue(withIdentifier: "startHome", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "startRegistration", sender: nil)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            } else {
                print("Not signed in.")
                // No user is signed in.
            }
        }
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

