//
//  RoutingRepositoryProtocol.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import Foundation
protocol RoutingRepositoryProtocol {
    
//    func createScript(script:Script)
    
//    func getAllScripts() -> [Script]?
    
    func getInitialUserFlow(completion: @escaping (UserFlow) -> Void)
    
    func getFirstRunStatus(completion: @escaping (Bool) -> Void)
    
    func getUserSubscriptionStatus(completion: @escaping (Bool) -> Void)
    
}
