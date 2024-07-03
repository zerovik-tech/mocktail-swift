//
//  RoutingViewInteractor.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import Foundation

protocol RoutingViewInteractorProtocol {
    
    func getInitialUserFlow(completion : @escaping(RoutingViewState.Result) -> Void)
    func getFirstRunStatus(completion : @escaping(Bool) -> Void)
    
}

class RoutingViewInteractor : RoutingViewInteractorProtocol {
    
  
    
    private let repository : RoutingRepository
    
    init(repository : RoutingRepository){
        self.repository = repository
    }
    
    func getInitialUserFlow(completion: @escaping (RoutingViewState.Result) -> Void) {
        
        repository.getInitialUserFlow { userflow in
            completion(.success(userflow))
        }
    }
    
    func getFirstRunStatus(completion: @escaping (Bool) -> Void) {
        repository.getFirstRunStatus { status in
            completion(status)
        }
    }
    
   
}
