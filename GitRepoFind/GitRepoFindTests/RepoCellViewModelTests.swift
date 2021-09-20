//
//  RepoCellViewModelTests.swift
//  GitRepoFindTests
//
//  Created by Ahmad Ragab on 20/09/2021.
//

import XCTest
@testable import GitRepoFind

class RepoCellViewModelTests: XCTestCase {
    
    var viewModel: RepoCellViewModel?

    override func setUpWithError() throws {
        MockHandler().getMockModel(jsonFileName: "ReposMockModel") { [weak self] (model: ReposModel) in
            if let items = model.items, items.count > 0 {
                self?.viewModel = RepoCellViewModel(repoModel: items[0])
            }
        }
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_RepoCellInit() {
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel!.repoModel.name == "swift")
    }
}
