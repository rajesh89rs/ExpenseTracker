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
    
    func loadWishlistedMutualFunds() {
        print("loadMutualFunds")
        sections = [MFWatchlistSectionModels]()
        if let mutualFunds = MutualFundManager().fetchWishListedMutualFunds() {
            var mutualFundModels = [MFWatchlistTableViewCellModel]()
            for mutualFund in mutualFunds {
                mutualFundModels.append(MFWatchlistTableViewCellModel.init(mfScheme: mutualFund))
            }
            self.sections.append(MFWatchlistSectionModels.init(watchlistCellModels: mutualFundModels))
        }
        self.delegate?.reloadData()
    }
    
    func didSelectMutualFund(code: String) {
        MutualFundManager().addMutualFundToWishlist(code: code)
        MutualFundManager().getMFNAVHistory(mfCode: code) { (success) in
            self.loadWishlistedMutualFunds()
        }
    }
    
}
