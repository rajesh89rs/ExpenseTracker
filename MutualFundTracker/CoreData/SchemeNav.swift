//
//  SchemeNav.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 11/03/21.
//

import UIKit
import CoreData

class SchemeNav: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(navObj: [String: Any], context: NSManagedObjectContext = MFCoreDataStack.shared.viewContext) {
        let entity = NSEntityDescription.entity(forEntityName: "SchemeNav", in: context)!
        super.init(entity: entity, insertInto: context)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if let dateStr = navObj["date"] as? String, let date = dateFormatter.date(from: dateStr) {
            self.date = date
        }
        if let nav = navObj["nav"] as? String, let navValue = Double(nav) {
            self.nav = navValue
        }
    }

}
