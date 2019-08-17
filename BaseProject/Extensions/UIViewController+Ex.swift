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
	func presentTransperant(_ viewControllerToPresent: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
		viewControllerToPresent.modalPresentationStyle = .overCurrentContext
		viewControllerToPresent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
		
		let overlayView = UIView()
		overlayView.frame = viewControllerToPresent.view.frame
		overlayView.backgroundColor = .clear
		overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
		viewControllerToPresent.view.insertSubview(overlayView, at: 0)
		
		present(viewControllerToPresent, animated: animated, completion: completion)
	}
    
    func presentTransperantCustom(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        
        let slideInPresentationDelegate = SlideInPresentationDelegate()
        viewControllerToPresent.transitioningDelegate = slideInPresentationDelegate
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.view.backgroundColor = .clear
        
        let overlayView = UIView()
        overlayView.frame = viewControllerToPresent.view.frame
        overlayView.backgroundColor = .clear
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewController)))
        viewControllerToPresent.view.insertSubview(overlayView, at: 0)
        
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
	
	@objc func dismissViewController() {
		dismiss(animated: false)
	}
    
    func addBlurView() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)
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

extension UIViewController {
    public class func topMostViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.keyWindow
        return UIViewController.topViewControllerWithRootController(keyWindow?.rootViewController)
    }
    
    public class func topViewControllerWithRootController(_ root: UIViewController?) -> UIViewController? {
        guard let rootController = root else {
            return nil
        }
        if let tabbarController = rootController as? UITabBarController {
            return UIViewController.topViewControllerWithRootController(tabbarController.selectedViewController)
        } else if let naviagationController = rootController as? UINavigationController {
            return UIViewController.topViewControllerWithRootController(naviagationController.visibleViewController)
        } else if let presentedController = rootController.presentedViewController {
            return UIViewController.topViewControllerWithRootController(presentedController)
        } else {
            for view in rootController.view.subviews {
                if let controller = view.next as? UIViewController {
                    return UIViewController.topViewControllerWithRootController(controller)
                }
            }
        }
        return root
    }
}

// MARK: - Helper add UIView load from nib
extension UIViewController {
	func addSubview(
		_ subview: UIView,
		constrainedTo anchorsView: UIView
		) {
		anchorsView.addSubview(subview)
		subview.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			subview.centerXAnchor.constraint(equalTo: anchorsView.centerXAnchor),
			subview.centerYAnchor.constraint(equalTo: anchorsView.centerYAnchor),
			subview.widthAnchor.constraint(equalTo: anchorsView.widthAnchor),
			subview.heightAnchor.constraint(equalTo: anchorsView.heightAnchor)
			])
	}
}

protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    static func loadStoryboard(_ name: StoryboardType) -> Self {
        return UIStoryboard(name: "\(name.rawValue)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

extension UIViewController: StoryboardLoadable {}
