//
//  UITableViewExtension.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 18/09/2021.
//

import UIKit

extension UITableView {
    
    /// To register cell using generics
    /// - Parameters:
    ///   - classType: generic class type in-order to get the reuse identifier of any UITableViewCell
    func registerCell<T: UITableViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.reuseIdentifier, bundle: .main), forCellReuseIdentifier: classType.reuseIdentifier)
    }
    
    /// To dequeue cells using generics
    /// - Parameters:
    ///   - indexPath: cell's indexPath
    func dequeueReusableCell<T: UITableViewCell>(_ classType: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: classType.reuseIdentifier, for: indexPath) as! T
    }
}
