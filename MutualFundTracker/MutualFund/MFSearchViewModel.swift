//
//  MFSearchViewModel.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 22/03/21.
//

import Foundation
import CoreData


protocol MFSearchViewModelDelegate: class {
    func reloadData()
}

struct MFSearchSectionModels {
    var mfSearchCellModels: [MFSearchTableViewCellModel]?
    init(mfSearchCellModels: [MFSearchTableViewCellModel]?) {
        self.mfSearchCellModels = mfSearchCellModels
    }
}

class MFSearchViewModel: NSObject {
    
    weak var delegate: MFSearchViewModelDelegate?
    var sections = [MFSearchSectionModels]()
    var mutualFundManager = MutualFundManager.init()
    
    func loadMutualFunds() {
        mutualFundManager.getMutualFunds {
            if let mutualFunds = self.mutualFundManager.fetchSavedMutualFunds() {
                var mutualFundModels = [MFSearchTableViewCellModel]()
                for mutualFund in mutualFunds {
                    mutualFundModels.append(MFSearchTableViewCellModel.init(mfScheme: mutualFund))
                }
                self.sections.append(MFSearchSectionModels.init(mfSearchCellModels: mutualFundModels))
            }
            self.delegate?.reloadData()
        }
    }
    
}
