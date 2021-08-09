//
//  MFWatchlistViewModel.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 07/03/21.
//

import Foundation
import CoreData


protocol MFWatchlistViewModelDelegate: class {
    func reloadData()
}

struct MFWatchlistSectionModels {
    var watchlistCellModels: [MFWatchlistTableViewCellModel]?
    init(watchlistCellModels: [MFWatchlistTableViewCellModel]?) {
        self.watchlistCellModels = watchlistCellModels
    }
}

class MFWatchlistViewModel: NSObject {
    
    weak var delegate: MFWatchlistViewModelDelegate?
    var sections = [MFWatchlistSectionModels]()
    var mfManager = MutualFundManager()
    
    func loadWishlistedMutualFunds() {
        print("loadMutualFunds")
        sections = [MFWatchlistSectionModels]()
        if let mutualFunds = mfManager.fetchWishListedMutualFunds() {
            var mutualFundModels = [MFWatchlistTableViewCellModel]()
            for mutualFund in mutualFunds {
                mutualFundModels.append(MFWatchlistTableViewCellModel.init(mfScheme: mutualFund))
            }
            self.sections.append(MFWatchlistSectionModels.init(watchlistCellModels: mutualFundModels))
        }
        self.delegate?.reloadData()
    }
    
    func didSelectMutualFund(code: String) {
        mfManager.addMutualFundToWishlist(code: code)
        mfManager.getMFNAVHistory(mfCode: code) { (success) in
            self.loadWishlistedMutualFunds()
        }
    }
    
    func handleDeleteMF(at indexPath: IndexPath) {
        guard let models = sections[indexPath.section].watchlistCellModels,
              models.count > indexPath.row,
              let mfCode = models[indexPath.row].code else {
            return
        }
        sections[indexPath.section].watchlistCellModels?.remove(at: indexPath.row)
        mfManager.deleteSavedMutualFunds(codes: [mfCode])
    }
    
}
