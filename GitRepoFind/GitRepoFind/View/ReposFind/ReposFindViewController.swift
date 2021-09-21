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

class ReposFindViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var reposSearchBar: UISearchBar!
    @IBOutlet weak var reposTableView: UITableView!
    
    // MARK: Local attributes
    let disposeBag = DisposeBag()
    let viewModel = ReposFindViewModel()
    var topTableViewCellIndexPath: IndexPath?
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureProgress()
        prepSearchBar()
        prepTableView()
        bindDataSourceToTableView()
    }
    
    // MARK: Delegate functions
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        let visibleIndexPaths = self.reposTableView.indexPathsForVisibleRows?.sorted { $0.row < $1.row }
        self.topTableViewCellIndexPath = visibleIndexPaths?.first
        
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            if let indexPath = self?.topTableViewCellIndexPath {
                self?.reposTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: Local functions
    fileprivate func prepSearchBar() {
        reposSearchBar.becomeFirstResponder()
        reposSearchBar.searchTextField.delegate = self
    }
    
    fileprivate func prepTableView() {
        reposTableView.registerCell(RepoTableViewCell.self)
    }
    
    fileprivate func handleSuccessState() {
        ProgressHUD.dismiss()
        ProgressHUD.colorStatus = .systemBlue
        ProgressHUD.show(icon: .succeed)
    }
    
    fileprivate func handleFailureState(_ error: String) {
        ProgressHUD.colorStatus = .systemRed
        ProgressHUD.showError(error, image: nil, interaction: true)
    }
    
    fileprivate func bindDataSourceToTableView() {
        let searchResultObservable = reposSearchBar.rx.text
            .orEmpty
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .debug()
            .flatMap { [weak self] query -> Observable<[BaseCellViewModel]> in
                guard let self = self else { return Observable<[BaseCellViewModel]>.just([]) }
                
                if query.isEmpty {
                    return Observable<[BaseCellViewModel]>.just([])
                } else {
                    ProgressHUD.show()
                    self.reposSearchBar.resignFirstResponder()
                    let resultObserver = self.viewModel.findGitReposBySearchQuery(query)
                    resultObserver.subscribe { cellsViewModels in
                        self.handleSuccessState()
                    } onError: {
                        let error = $0 as? NetworkError
                        self.handleFailureState(error?.errorMsg ?? ErrorType.genericError.rawValue)
                    }.disposed(by: self.disposeBag)
                    
                    return resultObserver
                }
            }
            .observe(on: MainScheduler.instance)
        
        searchResultObservable.bind(to: reposTableView.rx.items(cellIdentifier: RepoTableViewCell.self.reuseIdentifier)) { (row, viewModel: BaseCellViewModel, cell: RepoTableViewCell) in
            cell.setUp(model: viewModel)
            cell.delegate = self
        }.disposed(by: disposeBag)
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
