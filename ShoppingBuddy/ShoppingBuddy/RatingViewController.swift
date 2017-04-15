//
//  RatingViewController.swift
//  ShoppingBuddy
//
//  Created by Rithika Korrapolu on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import FirebaseStorage

class RatingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var imageView: UIImageView!
        
    @IBOutlet weak var comment: UITextField!
    
    @IBAction func submit(_ sender: Any) {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let users = FIRDatabase.database().reference().child("users")
        //let storage = FIRStorage.storage().reference()
        
        
        users.child(uid).child("rating").setValue(rating.rating)
        users.child(uid).child("comment").setValue(comment.text!)
        
        users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let partnerid = value?["partner"] as! String
            
            //print("Parter value: \(partnerid)")
            
            self.spinner.startAnimating()
            
            users.child(partnerid).child("rating").observe(FIRDataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? Double
                print("Value: \(value)")
                if value != nil {
                    users.child(partnerid).child("rating").removeAllObservers()
                    self.performSegue(withIdentifier: "results", sender: nil)
                    print("Both Ratings.")
                    self.spinner.stopAnimating()
                    //FIRDatabase.database().reference().child("queue").child(uid).removeValue()
                }
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        comment.delegate = self
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let databaseRef = FIRDatabase.database().reference()
        let storageRef = FIRStorage.storage().reference()
        let users = FIRDatabase.database().reference().child("users")
        
        users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let partnerid = value?["partner"] as! String
            
            databaseRef.child("users").child(partnerid).observeSingleEvent(of: .value, with: { (snapshot) in
                // check if user has photo
                if snapshot.hasChild("image"){
                    // set image locatin
                    let filePath = "\(partnerid)/\("userPhoto")"
                    // Assuming a < 10MB file, though you can change that
                    storageRef.child(filePath).data(withMaxSize: 10*1024*1024, completion: { (data, error) in
                        
                        let userPhoto = UIImage(data: data!)
                        self.imageView.image = userPhoto
                        print("loaded photo")
                    })
                }
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }

        

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
