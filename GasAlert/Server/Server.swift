//
//  Server.swift
//  GasAlert
//
//  Created by Davis Booth on 12/17/19.
//  Copyright © 2019 GasAlert. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage



class Server {
    class database {
        
        private init() {}
        
        static var sharedRef = Database.database().reference()
    }
    
    class fileStore {
        
        static var sharedRef = Storage.storage().reference()
        
        class func getDownloadURLAndDownloadAndCache(_ storageRef: StorageReference, imageView: UIImageView?=nil) {
            var urlString: String = ""
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    return
                }
                urlString = url!.absoluteString
                Server.fileStore.download(urlString, imageView: imageView)
            })
        }
        
        class func download(_ urlString: String, imageView: UIImageView?=nil) {
            let storageRef = Storage.storage().reference(forURL: urlString as String)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if error != nil {
                    return
                }
                let pic = UIImage(data: data!)
                if let imView = imageView {
                    imageView!.image = pic!
                }
            }
        }
    }

    class auth {
        
        private init() {}
        
        static var sharedRef = Auth.auth()
    }
}
