//
//  UploadImages.swift
//  ShoppingBuddy
//
//  Created by Rithika Korrapolu on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadImages: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var clickToUpload: UIButton!
    
    @IBAction func send(_ sender: Any) {
        
        if uploadedImage.image == nil {
            return
        }
        
        var data = NSData()
        let uid = FIRAuth.auth()!.currentUser!.uid
        let users = FIRDatabase.database().reference().child("users")
        let storage = FIRStorage.storage().reference()
        //let imagePath = storage.child("images").child(uid).child("image.jpg")
        var partnerid: String!
        data = UIImageJPEGRepresentation(uploadedImage.image!, 0.8)! as NSData
        // set upload path
        let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storage.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                print("Download URL: \(downloadURL)")
                //store downloadURL at database
                users.child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["image": downloadURL])
            }
            
        }
        
        print("Uploaded photo")
        
        users.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            partnerid = value?["partner"] as! String
            
            print("Parter value: \(partnerid)")
            
            self.spinner.startAnimating()
            
            users.child(partnerid).child("image").observe(FIRDataEventType.value, with: { (snapshot) in
                let value = snapshot.value as? String
                if value != nil {
                    users.child(uid).child("partner").removeAllObservers()
                    self.performSegue(withIdentifier: "ratePage", sender: nil)
                    print("Both images found.")
                    self.spinner.stopAnimating()
                    FIRDatabase.database().reference().child("queue").child(uid).removeValue()
                }
            })
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func observeForImage() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Use originalImage Here
            uploadedImage.image = originalImage
            clickToUpload.setTitle("", for: .normal)
            
            
        }
        picker.dismiss(animated: true)
    }

    
    
    @IBAction func openGallery(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
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
