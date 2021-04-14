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
        self.dismiss(animated: true, completion: nil)
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
    
    //SearchMFCell

}

extension MFSearchTableViewController: MFSearchViewModelDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
}
