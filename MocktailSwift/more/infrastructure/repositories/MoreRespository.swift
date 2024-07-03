//
//  MoreRespository.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation

class MoreRepository : MoreRepositoryProtocol {
    
    func getMore(completion: @escaping (More) -> Void) {
        MoreLocalDataSource.getMore { more in
            completion(more)
        }
    }
    
    func setMore(more: More, setMoreType: MoreType, completion: @escaping () -> Void) {
        MoreLocalDataSource.setMore(more: more, setMoreType: setMoreType) {
            completion()
        }
    }
    
    func checkDaysFirstRun(completion: @escaping (Bool) -> Void) {
        MoreLocalDataSource.checkDaysFirstRun { result in
            completion(result)
        }
    }
    
  
        
    
}
