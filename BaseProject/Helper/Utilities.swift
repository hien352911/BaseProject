//
//  Utilities.swift
//  BaseProject
//
//  Created by MTQ on 5/3/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import Foundation
import Reachability
import Photos
import AudioToolbox

class Utilities {
    static let shared = Utilities()
    // import Reachability
    var isReachability: Bool {
        switch Reachability()!.connection {
        case .none:
            return false
        case .cellular, .wifi:
            return true
        }
    }
    
    func saveVideoToAlbums(urlString: String) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/tempFile.mov"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
    }
    
    class var documentPath: String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return paths
    }
    
    class func makeHapticFeedback() {
        if Device.isIphone320width() {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlaySystemSound(1521)
        }
    }
}
