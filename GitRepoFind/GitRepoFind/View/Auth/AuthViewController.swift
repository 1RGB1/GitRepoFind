//
//  AuthViewController.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 22/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

class AuthViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var authButton: UIButton!
    
    // MARK: Locals
    private let disposeBag = DisposeBag()
    private let viewModel = AuthViewModel()
    
    // MARK: Life cylce functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindLoginButton()
    }

    // MARK: Local functions
    fileprivate func bindLoginButton() {
        authButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.authenticate().subscribe { [weak self] token in
                guard let self = self else { return }
                self.navigateToReposFind()
            } onError: {
                ProgressHUD.showError($0.localizedDescription, image: nil, interaction: true)
            }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
    
    fileprivate func navigateToReposFind() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        guard let vc = storyBoard.instantiateViewController(identifier: "ReposFindViewController") as? ReposFindViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
