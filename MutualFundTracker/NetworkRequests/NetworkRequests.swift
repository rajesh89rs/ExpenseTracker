//
//  NetworkRequests.swift
//  MutualFundTracker
//
//  Created by Rajesh RAMSHETTY SIDDARAJU on 07/03/21.
//

import UIKit
import Foundation

enum MFError: LocalizedError {
    case customError(message: String)
}

extension MFError {
    var errorDescription: String? {
        switch self {
        case let .customError(message):
            return NSLocalizedString(message, comment: "")
        }
    }
}

class NetworkRequests: NSObject {
    
    let FETCH_MF_URL = "https://api.mfapi.in/mf/search?q=axis"
    let NAV_HISTORY_URL = "https://api.mfapi.in/mf/"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getRequest(url: URL, completion: @escaping (_ responseData: Data?, _ error: MFError?) -> Void) {
        dataTask?.cancel()
        dataTask =
        defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if let error = error {
                completion(nil, MFError.customError(message: error.localizedDescription))
                return
            } else if let data = data, let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(data, nil)
                return
            } else {
                completion(nil, MFError.customError(message: "Unknown Error"))
                return
            }
        }
        dataTask?.resume()
    }
    
    func loadMutualFunds(completion: @escaping (_ mutualFundsJson: [[String: Any]]?) -> Void) {
        if let mutualFundURL = URL(string: FETCH_MF_URL) {
            self.getRequest(url: mutualFundURL) { (data, error) in
                if let data = data {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
                            DispatchQueue.main.async {
                                completion(jsonResult)
                                return
                            }
                        }
                    } catch let parseError as NSError {
                        print(parseError.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func getMutualFundNAVHistory(mfCode: String, completion: @escaping (_ navJson: [String: Any]?) -> Void) {
        if let navUrl = URL(string: NAV_HISTORY_URL + mfCode) {
            self.getRequest(url: navUrl) { (data, error) in
                if let data = data {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
                            DispatchQueue.main.async {
                                completion(jsonResult)
                                return
                            }
                        }
                    } catch let parseError as NSError {
                        print(parseError.localizedDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
}
