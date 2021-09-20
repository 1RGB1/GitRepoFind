//
//  ReposFindViewController.swift
//  GitRepoFind
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD
import UIScrollView_InfiniteScroll

class ReposFindViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var reposSearchBar: UISearchBar!
    @IBOutlet weak var reposTableView: UITableView!
    
    // MARK: Local attributes
    let disposeBag = DisposeBag()
    let viewModel = ReposFindViewModel()
    var isSearching = true
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProgress()
        prepSearchBar()
        prepTableView()
        bindObservers()
    }
    
    // MARK: Local functions
    fileprivate func configureProgress() {
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
    
    fileprivate func prepSearchBar() {
        reposSearchBar.becomeFirstResponder()
        reposSearchBar.searchTextField.delegate = self
    }
    
    fileprivate func prepTableView() {
        reposTableView.addInfiniteScroll { [weak self] (tableView) in
            guard let self = self else { return }
            self.viewModel.currentPage += 1
            self.isSearching = false
            self.loadData()
        }
    }
    
    fileprivate func bindObservers() {
        viewModel.cellsViewModelsObserver.subscribe { [weak self] cellsViewModels in
            
            guard let self = self else { return }
            if self.isSearching {
                ProgressHUD.dismiss()
                ProgressHUD.colorStatus = .systemBlue
                ProgressHUD.show(icon: .succeed)
            }
            self.reposTableView.reloadData()
            self.reposTableView.finishInfiniteScroll()
            
        } onError: { [weak self] in
            
            guard let self = self else { return }
            ProgressHUD.colorStatus = .systemRed
            ProgressHUD.showError($0.localizedDescription, image: nil, interaction: true)
            self.reposTableView.finishInfiniteScroll()
            
        }.disposed(by: disposeBag)
    }
    
    fileprivate func bindDataSourceToTableView() {
        let searchResultObservable = reposSearchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .debug()
            .flatMap { [weak self] query -> Observable<[BaseCellViewModel]> in
                if query.isEmpty {
                    return Observable<[BaseCellViewModel]>.just([])
                } else {
                    self?.viewModel.findReposInPage(1, bySearchQuery: query)
                    return Observable<[BaseCellViewModel]>.just(self?.viewModel.cellsViewModels ?? [])
                }
            }
            .observe(on: MainScheduler.instance)
        
        if viewModel.cellsViewModels.count > 0 {
            searchResultObservable.bind(to: reposTableView.rx.items(cellIdentifier: viewModel.cellsViewModels[0].type.reuseIdentifier)) { (row, viewModel: BaseCellViewModel, cell: CellConfigurable) in
                cell.setUp(model: viewModel)
                cell.delegate = self
            }.disposed(by: disposeBag)
        }
    }
    
    @objc
    fileprivate func loadData() {
        if isSearching { ProgressHUD.show() }
        viewModel.findReposInPage(viewModel.currentPage, bySearchQuery: viewModel.query)
    }
}

// MARK: Extensions
extension ReposFindViewController: UITextFieldDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension ReposFindViewController: RepoTableViewCellDelegate {
    func navigateToRepoButtonPressed(_ url: URL) {
        self.presentSFSafariViewControllerFor(url: url)
    }
}
