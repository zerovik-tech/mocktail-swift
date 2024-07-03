//
//  MoreRepositoryProtocol.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation

protocol MoreRepositoryProtocol {
    
    func getMore(completion : @escaping (More) -> Void)
    func setMore(more: More, setMoreType: MoreType, completion: @escaping () -> Void)
    func checkDaysFirstRun(completion : @escaping (Bool) -> Void)
    
    
}
