//
//  FileManager.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/22/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit
import Combine

protocol ImageFileManagerType {
    static func saveImage(name: String, data: Data) -> Bool
    static func imageWith(name: String) -> UIImage?
    static func imageExists(name: String) -> Bool
    var saveImage: AnySubscriber<(String, Data), Never> { get }
}

class ImageFileManager: ImageFileManagerType {
    private var bag = Set<AnyCancellable>()
    
    var saveImage: AnySubscriber<(String, Data), Never> {
        let subject = PassthroughSubject<(String, Data), Never>()
        subject
            .sink(receiveValue: { (name, data) in
                _ = ImageFileManager.saveImage(name: name, data: data)
            })
            .store(in: &bag)
        return AnySubscriber(subject)
    }
    
    class func saveImage(name: String, data: Data) -> Bool {
        guard let imagePath =  pathForImage(name) else {
            return false
        }
        do {
            try data.write(to: imagePath, options: .atomic)
            return true
        } catch {
            return false
        }
    }
    
    class func imageWith(name: String) -> UIImage? {
        guard let imagePath = pathForImage(name) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    class func imageExists(name: String) -> Bool {
        guard let imagePath = pathForImage(name) else {
            return false
        }
        return FileManager.default.fileExists(atPath: imagePath.path)
    }
    
    class func pathForImage(_ name: String) -> URL? {
        guard var imageDirectory = ImageFileManager.imageDirectoryPath() else {
            return nil
        }
        imageDirectory.appendPathComponent(name)
        return imageDirectory
    }
    
    class func imageDirectoryPath() -> URL? {
        let documentDirectory = self.documentDirectory
        let imageDirPath = documentDirectory.appendingPathComponent("Images")
        do {
            try FileManager.default.createDirectory(atPath: imageDirPath.path, withIntermediateDirectories: true)
            return imageDirPath
        } catch {
            return nil
        }
    }
    
    class var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

