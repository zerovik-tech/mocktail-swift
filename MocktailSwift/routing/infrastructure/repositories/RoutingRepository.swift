//
//  RoutingRepository.swift
//  Hashtag Generator Pro
//
//  Created by Sachin Pandey on 01/02/24.
//

import Foundation

class RoutingRepository : RoutingRepositoryProtocol {
    
    func getInitialUserFlow(completion: @escaping (UserFlow) -> Void) {
        RoutingLocalDataSource.getFirstRunStatus { isFirstRun in
            
            if isFirstRun {
                RoutingLocalDataSource.setFirstRunFalse {}
                completion(.onboarding)
                return
            }
            
            PaywallLocalDataSource.getSubscriptionExpiryDate { date in
                if (Date.now > date) {
                    completion(.paywall)
                } else {
                    completion(.home)
                }
                return
            }

            
        }
    }
    
    func getFirstRunStatus(completion: @escaping (Bool) -> Void) {
        RoutingLocalDataSource.getFirstRunStatus { status in
            if status {
                
            }
            completion(status)
            
            
        }
    }
    
    func getUserSubscriptionStatus(completion: @escaping (Bool) -> Void) {
        PaywallLocalDataSource.getSubscriptionExpiryDate { date in
            if (Date.now > date) {
                completion(false)
            } else {
                completion(true)
            }
                
        }
    }

    
//    func getFirstRunStatus(completion: @escaping (Bool) -> Void) {
//        <#code#>
//    }
    
    
}
