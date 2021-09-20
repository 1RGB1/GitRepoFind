//
//  RepoCellViewModel.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import Foundation
import UIKit

struct RepoCellViewModel: BaseCellViewModel {
    
    var repoModel: RepoModel
    
    init(repoModel: RepoModel) {
        self.repoModel = repoModel
    }
}
