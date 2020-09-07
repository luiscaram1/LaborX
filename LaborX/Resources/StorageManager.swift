//
//  StorageManager.swift
//  LaborX
//
//  Created by Luis Caram on 9/6/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    ///Uploads Pcitrue to firebase Storage and returns completion with URL to dowenload
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                //failed
                print("Failed to upload to database for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
            guard let url = url else {
                print("Failed to get download url")
                completion( .failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
        })
    })
}
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
        
    }
    
    public func downlaodURL(for path: String,  completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            
            completion(.success(url))
        })
        }
}
