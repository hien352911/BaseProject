//
//  UIViewController+Ex.swift
//  BaseProject
//
//  Created by MTQ on 5/15/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

extension UIViewController {
    func removeBackButtonTitle() {
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

extension UIViewController {
    func presentTransperant(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}

extension UIViewController {
    func saveImageToPhotosAlbum(image: UIImage, isShowAlert: Bool) {
        if isShowAlert {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        } else {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
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
