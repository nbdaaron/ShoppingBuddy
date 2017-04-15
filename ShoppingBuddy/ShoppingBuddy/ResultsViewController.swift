//
//  ResultsViewController.swift
//  ShoppingBuddy
//
//  Created by Aaron Kau on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import FirebaseStorage

class ResultsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var comments: UILabel!

    @IBOutlet weak var stars: CosmosView!
    override func viewDidLoad() {
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        let users = FIRDatabase.database().reference().child("users")

        
        super.viewDidLoad()
        
        users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let partnerid = value?["partner"] as! String
            
            //print("Parter value: \(partnerid)")
            
            //self.spinner.startAnimating()
            
            users.child(partnerid).observeSingleEvent(of: .value, with: {(snapshot) in
                let val = snapshot.value as? NSDictionary
                let rate = val?["rating"] as? Double
                let comment = val?["comment"] as? String
                
                self.comments.text = comment!
                self.stars.rating = rate!
                
                users.child(partnerid).child("image").removeValue()
                users.child(partnerid).child("partner").removeValue()
                users.child(partnerid).child("rating").removeValue()
                users.child(partnerid).child("comment").removeValue()
                
            }) {
                error in
                print(error)
            }
        }) {
            error in
            print(error)
        }
        
        
        let filePath = "\(uid)/\("userPhoto")"
        // Assuming a < 10MB file, though you can change that
        FIRStorage.storage().reference().child(filePath).data(withMaxSize: 10*1024*1024, completion: { (data, error) in
            
            let userPhoto = UIImage(data: data!)
            self.imageView.image = userPhoto
            print("loaded photo")
        })
        
        

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
