//
//  PaywallLocalDataSource.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation

import SwiftUI

protocol PaywallLocalDataSourceProtocol {
    static func setSubscriptionExpiryDate(date: Date, completion: @escaping () -> Void)
    static func getSubscriptionExpiryDate(completion: @escaping (Date) -> Void)
}



class PaywallLocalDataSource: PaywallLocalDataSourceProtocol {
    
    enum SubscriptionString: String {
        case subscriptionPlanExpiry = "subscriptionPlanExpiry"
    }
    
    static func setSubscriptionExpiryDate(date: Date, completion: @escaping () -> Void) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: SubscriptionString.subscriptionPlanExpiry.rawValue )
        completion()
    }
    
    static func getSubscriptionExpiryDate(completion: @escaping (Date) -> Void) {
        let userDefaults = UserDefaults.standard
        var date: Date = Date.distantPast
        date = userDefaults.object(forKey: SubscriptionString.subscriptionPlanExpiry.rawValue) as? Date ?? Date.distantPast
        completion(date)
    }
    

    
}
