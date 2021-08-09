//
//  MFSearchTableViewController.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 22/03/21.
//

import UIKit

protocol MFSearchTableViewControllerDelegate: class {
    func didSelectMutualFund(code: String)
}

class MFSearchTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = MFSearchViewModel()
    weak var delegate: MFSearchTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.title = "Search MF"
        navigationItem.searchController = searchController
        viewModel.loadMutualFunds()
        searchController.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].mfSearchCellModels?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let models = viewModel.sections[indexPath.section].mfSearchCellModels {
            let model = models[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMFCell", for: indexPath) as? MFSearchTableViewCell {
                cell.setupWithModel(model: model)
                return cell
            }
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let models = viewModel.sections[indexPath.section].mfSearchCellModels {
            if let mfCode = models[indexPath.row].code {
                self.delegate?.didSelectMutualFund(code: mfCode)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

}

extension MFSearchTableViewController: MFSearchViewModelDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}
