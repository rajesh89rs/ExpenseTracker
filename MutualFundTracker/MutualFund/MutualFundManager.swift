//
//  MutualFundManager.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 29/03/21.
//

import UIKit
import CoreData

class MutualFundManager {
    
    let context = MFCoreDataStack.shared.viewContext
    
    static var lastMutualFundsSync: Date? {
        get {
            let defaults = UserDefaults.standard
            if let fetchedDate = defaults.object(forKey: "lastMutualFundsSync") as? Date {
                return fetchedDate
            }
            return nil
        }
        set(newVal) {
            let defaults = UserDefaults.standard
            defaults.set(newVal, forKey: "lastMutualFundsSync")
        }
    }
    
    static var syncMutualFunds: Bool {
        if let lastMFSyncDate = MutualFundManager.lastMutualFundsSync {
            let diffComponents = Calendar.current.dateComponents([.hour], from: lastMFSyncDate, to: Date())
            if let daysSince = diffComponents.day, daysSince > 1 {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func getMutualFunds(_ completion: @escaping () -> Void) {
        if MutualFundManager.syncMutualFunds {
            loadMutualFunds(completion)
        } else {
            completion()
        }
    }
    
    func loadMutualFunds(_ completion: @escaping () -> Void) {
        NetworkRequests().loadMutualFunds { (mutualFundsJson) in
            if let mutualFunds = mutualFundsJson {
                self.deleteSavedMutualFunds()
                MutualFundManager.lastMutualFundsSync = Date()
                self.saveMutualFunds(mutualFunds)
            }
            completion()
        }
    }
    
    func fetchSavedMutualFunds() -> [MFScheme]? {
        let fetchRequest: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        do {
            let mutualFunds = try context.fetch(fetchRequest)
            return mutualFunds
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchWishListedMutualFunds() -> [MFScheme]? {
        let fetchRequest: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "wishListed = true")
        do {
            let mutualFunds = try context.fetch(fetchRequest)
            return mutualFunds
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchMutualFundsCount() -> Int {
        var mfCount = 0
        let mFSchemeFetch: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        do {
            mfCount = try context.count(for: mFSchemeFetch)
        } catch {
            print(error)
        }
        return mfCount
    }
    
    func saveMutualFunds(_ mutualFunds: [[String: Any]]) {
        for mutualFundObj in mutualFunds {
            _ = MFScheme.init(mutualFundObj: mutualFundObj, context: context)
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteSavedMutualFunds() {
        let deleteMFSchemeFetch: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        let deleteNavFetch: NSFetchRequest<SchemeNav> = SchemeNav.fetchRequest()
        do {
            let mutualFunds = try context.fetch(deleteMFSchemeFetch)
            if mutualFunds.count > 0 {
                for mutualFund in mutualFunds {
                    context.delete(mutualFund)
                }
            }
            let schemeNavs = try context.fetch(deleteNavFetch)
            if schemeNavs.count > 0 {
                for nav in schemeNavs {
                    context.delete(nav)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func deleteSavedMutualFunds(codes: [String]) {
        let request: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        request.predicate = NSPredicate.init(format: "code IN %@", codes)
        do {
            let mfSchemes = try context.fetch(request)
            for mfScheme in mfSchemes {
                context.delete(mfScheme)
            }
            try context.save()
        } catch {
            print("delete: ", error)
        }
    }
    
    func addMutualFundToWishlist(code: String) {
        let fetchRequest: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code = %@", code)
        do {
            let mutualFunds = try context.fetch(fetchRequest)
            if let mutualFund = mutualFunds.first {
                mutualFund.wishListed = true
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func fetchMutualFund(code: String) -> MFScheme? {
        let fetchRequest: NSFetchRequest<MFScheme> = MFScheme.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code = %@", code)
        do {
            let mutualFunds = try context.fetch(fetchRequest)
            return mutualFunds.first
        } catch {
            print(error)
        }
        return nil
    }
    
    func getMFNAVHistory(mfCode: String, completion: @escaping (_ success: Bool) -> Void) {
        if !mfCode.isEmpty {
            NetworkRequests().getMutualFundNAVHistory(mfCode: mfCode) { (responseData) in
                if let navHistory = responseData?["data"] as? [[String: Any]] {
                    self.saveMFNavHistory(mfCode: mfCode, navHistory)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func saveMFNavHistory(mfCode: String, _ navHistoryJson: [[String: Any]]) {
        if let mfScheme = fetchMutualFund(code: mfCode) {
            if let navs = mfScheme.performance?.array as? [SchemeNav] {
                for nav in navs {
                    context.delete(nav)
                }
            }
            for navJson in navHistoryJson {
                let nav = SchemeNav.init(navObj: navJson, context: context)
                mfScheme.addToPerformance(nav)
            }
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }

}
