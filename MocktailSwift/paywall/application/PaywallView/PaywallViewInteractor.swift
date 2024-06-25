//
//  PaywallViewInteractor.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
protocol PaywallViewInteractorProtocol {
    
    func fetchSubscriptionPlans(completion: @escaping (PaywallViewState.Result) -> Void)
    
    func fetchCurrentOffering(completion: @escaping (PaywallViewState.Result) -> Void)
    
    func restoreSubscription(completion: @escaping (PaywallViewState.Result) -> Void)
    
    func purchaseSubscription(plan: SubscriptionPlan, completion: @escaping (PaywallViewState.Result) -> Void)
    
    func getUserSubscriptionStatus(completion: @escaping (PaywallViewState.Result) -> Void)
    
}

class PaywallViewInteractor: PaywallViewInteractorProtocol {
    private let repository: PaywallRepositoryProtocol
    
    init(repository: PaywallRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchSubscriptionPlans(completion: @escaping (PaywallViewState.Result) -> Void) {
        repository.fetchSubscriptionPlans { result in
            switch result {
            case .success(let plans):
                completion(.success(.subscriptionPlans(plans)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCurrentOffering(completion: @escaping (PaywallViewState.Result) -> Void) {
        repository.fetchCurrentOffering { result in
            switch result {
            case .success(let offering):
                completion(.success(.currentOffering(offering)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func restoreSubscription(completion: @escaping (PaywallViewState.Result) -> Void) {
        repository.restoreSubscriptionPlan { result in
            switch result {
            case .success():
                completion(.success(.isUserSubscribed(true)))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }
    
    func purchaseSubscription(plan: SubscriptionPlan, completion: @escaping (PaywallViewState.Result) -> Void) {
        repository.purchaseSubscriptionPlan(plan: plan) { result in
            switch result {
            case .success():
                completion(.success(.isUserSubscribed(true)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
        func getUserSubscriptionStatus(completion: @escaping (PaywallViewState.Result) -> Void) {
            repository.getSubscriptionExpiry() { date in
                
                var result: Bool {
                    if Date.now > date {
                        return false
                    } else {
                        return true
                    }
                }
                
                completion(.success(.isUserSubscribed(result)))
            }
        }
    
}

