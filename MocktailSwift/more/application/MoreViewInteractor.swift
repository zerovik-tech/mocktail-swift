//
//  MoreViewInteractor.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation

protocol MoreViewInteractorProtocol {
    
    func getMore(completion : @escaping (MoreViewState.Result) -> Void)
    func setMore(more: More, setMoreType: MoreType, completion: @escaping (MoreViewState.Result) -> Void)
    func checkDaysFirstRun(completion : @escaping (Bool) -> Void)
    
    
    
}

class MoreViewInteractor : MoreViewInteractorProtocol {

    
    private let repository: MoreRepositoryProtocol
    
    init(repository: MoreRepositoryProtocol) {
        self.repository = repository
    }
    
    func getMore(completion: @escaping (MoreViewState.Result) -> Void) {
        repository.getMore { more in
            completion(.success(more))
        }
    }
    
    func setMore(more: More, setMoreType: MoreType, completion: @escaping (MoreViewState.Result) -> Void) {
        repository.setMore(more: more, setMoreType: setMoreType) {
            completion(.success(more))
        }
    }
    
    func checkDaysFirstRun(completion: @escaping (Bool) -> Void) {
        repository.checkDaysFirstRun { result in
            completion(result)
        }
    }
    
    
    
}
