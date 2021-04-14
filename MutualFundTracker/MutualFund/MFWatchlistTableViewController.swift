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
        viewModel.delegate = self
        self.title = "Watchlist"
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.searchController = searchController
        viewModel.loadWishlistedMutualFunds()
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "MutualFund", bundle: nil)
        guard let mfSearchTableViewController = storyboard.instantiateViewController(withIdentifier: "MFSearchTableViewController") as? MFSearchTableViewController else {
            return
        }
        mfSearchTableViewController.delegate = self
        let navigationController: MFNavigationVC = MFNavigationVC(rootViewController: mfSearchTableViewController as UIViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].watchlistCellModels?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let models = viewModel.sections[indexPath.section].watchlistCellModels {
            let model = models[indexPath.row]
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WatchlistCell", for: indexPath) as? MFWatchlistTableViewCell {
                cell.setupWithModel(model: model)
                return cell
            }
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MFWatchlistTableViewController: MFWatchlistViewModelDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}

extension MFWatchlistTableViewController: MFSearchTableViewControllerDelegate {
    func didSelectMutualFund(code: String) {
        self.viewModel.didSelectMutualFund(code: code)
    }
}
