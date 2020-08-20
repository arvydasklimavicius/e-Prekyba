//
//  Downloader.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-18.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping(_ imageLinks: [String]) -> ()) {
    
    if Reachabilty.HasConnection() {
        var uploadedImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images {
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImagesToFirestore(imageData: imageData!, fileName: fileName) { (imageLink) in
                if imageLink != nil {
                    imageLinkArray.append(imageLink!)
                    uploadedImagesCount += 1
                    
                    if uploadedImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            nameSuffix += 1
        }
        
    } else {
        print("No Internet Connection")
    }
}

func saveImagesToFirestore(imageData: Data, fileName: String, completion: @escaping(_ imageLink: String?) -> ()) {
    var task: StorageUploadTask!
    let storageRef = storage.reference(forURL: cFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        task.removeAllObservers()
        
        if error != nil {
            print("Error uploading image", error!.localizedDescription)
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        }
    })
}

func downloadImages(imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> ()) {
    var imagesArray: [UIImage] = []
    var downloadCounter = 0
    for link in imageUrls {
        let url = NSURL(string: link)
        let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
        downloadQueue.async {
            downloadCounter += 1
            let data = NSData(contentsOf: url! as URL)
            if data != nil {
                imagesArray.append(UIImage(data: data! as Data)!)
                if downloadCounter == imagesArray.count {
                    DispatchQueue.main.async {
                        completion(imagesArray)
                    }
                }
            } else {
                print("error downloading image")
                completion(imagesArray)
            }
        }
    }
}
