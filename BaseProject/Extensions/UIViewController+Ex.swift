//
//  UIViewController+Ex.swift
//  BaseProject
//
//  Created by MTQ on 5/15/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit
import Photos

extension UIViewController {
    public func removeBackButtonTitle() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

extension UIViewController {
    func presentTransperant(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}

extension UIViewController {
    func saveImageToPhotosAlbum(image: UIImage, isShowAlertCompletionSaved: Bool, completionRequestSavePhoto: (() -> Void)? = nil) {
        if isShowAlertCompletionSaved {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
                switch authorizationStatus {
                case .authorized:
                    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                default:
                    break
                }
                completionRequestSavePhoto?()
            }
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}

extension UIViewController {
    func setupNavigationDefault(needBottomLine: Bool = true) {
        let tintColor = UIColor(hex: 0xED3A50)
        
        self.setupNavigationAppearend(backgroundImage: UIImage(),
                                      shadowImage: UIImage(),
                                      hidden: false,
                                      translucent: false,
                                      backgroundColor: UIColor.white ,
                                      tintColor: tintColor!,
                                      statusBarStyle: UIStatusBarStyle.default, needBottomLine: needBottomLine)
    }
    
    func setupNavigationAppearend(backgroundImage: UIImage = UIImage(),
                                  shadowImage: UIImage = UIImage(),
                                  hidden: Bool = false,
                                  translucent: Bool = true,
                                  backgroundColor: UIColor = UIColor.clear,
                                  tintColor: UIColor = UIColor.white,
                                  barStyle: UIBarStyle = UIBarStyle.default,
                                  statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.lightContent, needBottomLine: Bool = true) {
        self.navigationController?.navigationBar.setBackgroundImage(backgroundImage, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = shadowImage
        self.navigationController?.navigationBar.isHidden = hidden
        self.navigationController?.navigationBar.isTranslucent = translucent
        self.navigationController?.navigationBar.backgroundColor = backgroundColor
        self.navigationController?.view.backgroundColor = backgroundColor
        self.navigationController?.navigationBar.barStyle = barStyle
        let bottomLineColor = UIColor(hex: 0xEEEEEE)
//        self.navigationController?.navigationBar.layer.addBorder(edge: UIRectEdge.bottom, color: needBottomLine ? bottomLineColor : UIColor.clear, thickness: 0.6)
        UIApplication.shared.statusBarStyle = statusBarStyle
        UINavigationBar.appearance().tintColor = tintColor
        self.setNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.isStatusBarHidden = false
    }
}

// MARK: - UITextFieldDelegate
extension UIViewController: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        view.endEditing(true) // or do something
    }
}

extension UIViewController {
    public func addLeftBarButtonWithImage(buttonImage: UIImage, tintColor: UIColor? = UIColor(hex: 0xB4B4B4)) {
        let leftButton = UIBarButtonItem(image: buttonImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.leftAction))
        leftButton.tintColor = tintColor
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func leftAction() {
        
    }
}
