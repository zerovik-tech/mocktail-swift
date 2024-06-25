//
//  RoutingRepositoryProtocol.swift
//  Hashtag Generator Pro
//
//  Created by Sachin Pandey on 01/02/24.
//

import Foundation

protocol RoutingRepositoryProtocol {
    
//    func createScript(script:Script)
    
//    func getAllScripts() -> [Script]?
    
    func getInitialUserFlow(completion: @escaping (UserFlow) -> Void)
    
    func getFirstRunStatus(completion: @escaping (Bool) -> Void)
    
    func getUserSubscriptionStatus(completion: @escaping (Bool) -> Void)
    
}
