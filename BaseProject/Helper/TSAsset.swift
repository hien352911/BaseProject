//
//  TSAsset.swift
//  BaseProject
//
//  Created by MTQ on 9/14/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation

public struct TSAsset {
    static func removeFileIfExists(fileURL : URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(at: fileURL)
            }
            catch {
                print("Could not delete exist file so cannot write to it")
            }
        }
    }
}
