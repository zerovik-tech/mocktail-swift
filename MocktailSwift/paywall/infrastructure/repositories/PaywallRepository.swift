//
//  PaywallRepository.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import RevenueCat

class PaywallRepository: PaywallRepositoryProtocol {
    func fetchSubscriptionPlans(completion: @escaping (Result<[SubscriptionPlan], Error>) -> Void) {
        PaywallRemoteDataSource.fetchSubscriptionPlans { result in
            switch result {
            case .success(let plans):
                completion(.success(plans))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func fetchCurrentOffering(completion: @escaping (Result<Offering, Error>) -> Void) {
        PaywallRemoteDataSource.fetchCurrentOffering { result in
            switch result {
            case .success(let offering):
                completion(.success(offering))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func restoreSubscriptionPlan(completion: @escaping (Result<Void, Error>) -> Void) {
        PaywallRemoteDataSource.restoreSubscription { result in
            switch result {
            case .success(let date):
                PaywallLocalDataSource.setSubscriptionExpiryDate(date: date) {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func purchaseSubscriptionPlan(plan: SubscriptionPlan, completion: @escaping (Result<Void, Error>) -> Void) {
        PaywallRemoteDataSource.purchaseSubscription(plan: plan) { result in
            switch result {
            case .success(let date):
                PaywallLocalDataSource.setSubscriptionExpiryDate(date: date) {
                    completion(.success(()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSubscriptionExpiry(completion: @escaping (Date) -> Void) {
        PaywallLocalDataSource.getSubscriptionExpiryDate { date in
            completion(date)
            
            PaywallRemoteDataSource.fetchSubscriptionExpiry { result in
                switch result {
                case .success(let newDate):
                    PaywallLocalDataSource.setSubscriptionExpiryDate(date: newDate) {
                        completion(newDate)
                    }
                case .failure(_):
                    completion(date)
                }
            }
            
        }
    }
}
