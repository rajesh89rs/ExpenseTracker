//
//  MFScheme.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 11/03/21.
//

import UIKit
import CoreData

class MFScheme: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(mutualFundObj: [String: Any], context: NSManagedObjectContext = MFCoreDataStack.shared.viewContext) {
        let entity = NSEntityDescription.entity(forEntityName: "MFScheme", in: context)!
        super.init(entity: entity, insertInto: context)
        if let code = mutualFundObj["schemeCode"] as? Int64 {
            self.code = String(describing: code)
        }
        if let name = mutualFundObj["schemeName"] as? String {
            self.name = name
        }
        self.wishListed = false
    }

}
