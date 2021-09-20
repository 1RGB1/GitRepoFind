//
//  RepoTableViewCell.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import UIKit
import Kingfisher

protocol RepoTableViewCellDelegate: BaseCellDelegate {
    func navigateToRepoButtonPressed(_ url: URL)
}

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoAvatarImage: UIImageView!
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoLanguageLabel: UILabel!
    @IBOutlet weak var repoForksCountLabel: UILabel!
    @IBOutlet weak var repoWatchersCountLabel: UILabel!
    
    weak var delegate: BaseCellDelegate?
    var viewModel: RepoCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContentView.setCornerRadiusWithShadow(cornerRadius: 8)
    }
    
    @IBAction func navigateToRepoButtonPressed(_ sender: Any) {
        guard let model = viewModel, let urlStr = model.repoModel.html_url, let url = URL(string: urlStr) else { return }
        (delegate as? RepoTableViewCellDelegate)?.navigateToRepoButtonPressed(url)
    }
}

extension RepoTableViewCell: CellConfigurable {
    func setUp(model: BaseCellViewModel) {
        guard let model = model as? RepoCellViewModel else { return }
        
        viewModel = model
        
        repoNameLabel.text = model.repoModel.name ?? "N/A"
        repoDescriptionLabel.text = model.repoModel.description ?? "N/A"
        
        let logoURL = URL(string: model.repoModel.owner?.avatar_url ?? "")
        repoAvatarImage.kf.setImage(with: logoURL, placeholder: UIImage(named: "githubLogo"), options: [.transition(.fade(1))])
        
        let imageURL = URL(string: model.repoModel.html_url ?? "")
        repoAvatarImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(1))])
        
        repoLanguageLabel.text = model.repoModel.language ?? "N/A"
        
        if let forks = model.repoModel.forks {
            repoForksCountLabel.text = "\(forks)"
        } else {
            repoForksCountLabel.text = "N/A"
        }
        
        if let watchers = model.repoModel.watchers {
            repoWatchersCountLabel.text = "\(watchers)"
        } else {
            repoWatchersCountLabel.text = "N/A"
        }
    }
}
