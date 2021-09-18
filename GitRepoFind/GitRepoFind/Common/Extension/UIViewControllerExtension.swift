//
//  UIViewControllerExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 18/09/2021.
//

import Foundation
import SafariServices

extension UIViewController {
    func presentSFSafariViewControllerFor(url: URL) {
        let safariViewcontroller = SFSafariViewController(url: url)
        present(safariViewcontroller, animated: true, completion: nil)
    }
}
