//
//  UIViewControllerExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 18/09/2021.
//

import Foundation
import SafariServices
import ProgressHUD

extension UIViewController {
    
    func presentSFSafariViewControllerFor(url: URL) {
        let safariViewcontroller = SFSafariViewController(url: url)
        present(safariViewcontroller, animated: true, completion: nil)
    }
    
    func configureProgress() {
        ProgressHUD.animationType = .lineScaling
        ProgressHUD.colorHUD = .systemGray
        ProgressHUD.colorBackground = .lightGray
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.fontStatus = UIFont(name: "HelveticaNeue-Regular", size: 18) ?? .boldSystemFont(ofSize: 18)
        
        let defaultImageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        if let successImage = UIImage(systemName: "checkmark.circle", withConfiguration: defaultImageConfiguration) {
            ProgressHUD.imageSuccess = successImage
        }
        if let faildImage = UIImage(systemName: "xmark.octagon", withConfiguration: defaultImageConfiguration) {
            ProgressHUD.imageError = faildImage
        }
    }
}
