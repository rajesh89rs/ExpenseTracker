//
//  MFWatchlistTableViewController.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 07/03/21.
//

import UIKit

class MFWatchlistTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = MFWatchlistViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Watchlist"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.searchController = searchController
        self.tableView.tableFooterView = UIView()
        viewModel.sections.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.loadWishlistedMutualFunds()
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "MutualFund", bundle: nil)
        guard let mfSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "MFSearchTableViewController") as? MFSearchTableViewController else {
            return
        }
        mfSearchTableViewController.delegate = self
        /*
        let navigationController: MFNavigationVC = MFNavigationVC(rootViewController: mfSearchTableViewController as UIViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navigationController, animated: true, completion: nil)
        */
        show(mfSearchTableViewController, sender: self)
        
        //TODO: When trying to show the VC in fullscreen, the top navbar is missing, Hence above had used specific navigation controller and then show api which just presents the vc into current vc's navC or splitVc
        //showDetailViewController(mfSearchTableViewController, sender: self)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.sections.value.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.value[section].watchlistCellModels?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let models = viewModel.sections.value[indexPath.section].watchlistCellModels {
            let model = models[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistCell", for: indexPath) as? MFWatchlistTableViewCell {
                cell.setupWithModel(model: model)
                return cell
            }
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.handleDeleteMF(at: indexPath)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension MFWatchlistTableViewController: MFSearchTableViewControllerDelegate {
    func didSelectMutualFund(code: String) {
        self.viewModel.didSelectMutualFund(code: code)
    }
}
