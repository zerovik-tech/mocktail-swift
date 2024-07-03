//
//  SubscriptionPlan.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import RevenueCat

struct SubscriptionPlan: Equatable {
    
    var identifier: String
    var name: String
    var isTrialEligible: Bool
    var localizedPrice: String
    var rcPackage: Package?
    
    static func empty() -> SubscriptionPlan {
        return SubscriptionPlan(identifier: "", name: "", isTrialEligible: false, localizedPrice: "", rcPackage: nil)
    }
}
