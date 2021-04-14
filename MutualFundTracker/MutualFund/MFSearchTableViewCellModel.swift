//
//  MFSearchTableViewCellModel.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 22/03/21.
//

import Foundation

class MFSearchTableViewCellModel {
    var name: String?
    var code: String?
    
    init(mfScheme: MFScheme) {
        name = mfScheme.name
        code = mfScheme.code
    }
    
}
