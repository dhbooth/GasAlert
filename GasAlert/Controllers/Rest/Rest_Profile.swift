//
//  Rest_Profile.swift
//  GasAlert
//
//  Created by Davis Booth on 4/10/20.
//  Copyright © 2020 GasAlert. All rights reserved.
//

import UIKit

class Rest_Profile: UIViewController, UINavigationControllerDelegate ,UIImagePickerControllerDelegate {

    @IBOutlet weak var placeholderImg: UIImageView!
    @IBOutlet weak var restNameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeholderImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(spawnImagePicker))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        self.placeholderImg.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureAesthetic()
    }
    
    @objc func spawnImagePicker() {
        // Set up.
        var imageController = UIImagePickerController()
        imageController.delegate = self
        imageController.allowsEditing = true
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        // Present.
        self.present(imageController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Set.
        if let img: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.placeholderImg.layer.cornerRadius = self.placeholderImg.layer.frame.width/2
            self.placeholderImg.image = img
            self.placeholderImg.alpha = 1.0
            self.placeholderImg.contentMode = .scaleAspectFill

        }

        // Dismiss.
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureAesthetic() {
        self.confirmButton.layer.cornerRadius = 7
    }
    

    @IBAction func confirmButton(_ sender: Any) {
        if !(self.restNameTF.text?.isEmpty ?? false || self.restNameTF.text == "") {
            let addr = self.addressTF.text ?? ""
            let state = self.stateTF.text ?? ""
            let zip = self.zipTF.text ?? ""
            let fullAddr = addr + ", " + state + " " + zip
            let info = ["name" : self.restNameTF.text ?? "",
                        "address" : fullAddr,
                        "prof-pic" : ""
            ]
            Server.database.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).setValue(info)
           
            if let sized_img = self.placeholderImg.image!.resizeWithWidth(width: 400) {
                if let uploadableImage = sized_img.jpegData(compressionQuality: 0.5) {
                    Server.fileStore.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).putData(uploadableImage, metadata: nil) { (metadata, error) in
                        if error != nil {
                            return
                        }
                        else {
                            Server.fileStore.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).downloadURL { (url, error) in
                                if error != nil {
                                    return
                                }
                                else {
                                    Server.database.sharedRef.child("Restaurants").child(Server.auth.currentLocalUser!.id!).child("prof-pic").setValue(url?.absoluteString ?? "")
                                }
                            }
                        }
                    }
                }
            }
            
            // Seg.
            self.performSegue(withIdentifier: "toRestaurantHome", sender: self)
            
            
        }
        
    }

}

extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
