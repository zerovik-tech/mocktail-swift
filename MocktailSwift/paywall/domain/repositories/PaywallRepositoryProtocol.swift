//
//  PaywallRepositoryProtocol.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import RevenueCat

protocol PaywallRepositoryProtocol {
    
    func fetchSubscriptionPlans(completion: @escaping (Result<[SubscriptionPlan], Error>) -> Void)
    
    func fetchCurrentOffering(completion: @escaping (Result<Offering, Error>) -> Void)
    
    func restoreSubscriptionPlan(completion: @escaping (Result<Void, Error>) -> Void)
    
    func purchaseSubscriptionPlan(plan: SubscriptionPlan, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getSubscriptionExpiry(completion: @escaping (Date) -> Void)
    
    
}
