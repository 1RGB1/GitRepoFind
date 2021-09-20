//
//  RepoCellViewModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import UIKit

struct RepoCellViewModel: BaseCellViewModel {
    
    var type: UITableViewCell.Type
    var repoModel: RepoModel
    
    init(repoModel: RepoModel) {
        self.type = RepoTableViewCell.self
        self.repoModel = repoModel
    }
}
