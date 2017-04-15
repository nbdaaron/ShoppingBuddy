//
//  UploadImages.swift
//  ShoppingBuddy
//
//  Created by Rithika Korrapolu on 4/15/17.
//  Copyright © 2017 Aaron Kau. All rights reserved.
//

import UIKit

class UploadImages: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadedImage: UIImageView!
    
    @IBOutlet weak var clickToUpload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
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
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // Use editedImage Here
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
