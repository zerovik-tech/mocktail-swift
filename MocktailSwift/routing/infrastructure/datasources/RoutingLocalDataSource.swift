//
//  RoutingLocalDataSource.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import Foundation

//SUGGESTION - IT WOULD BE BETTER IF THIS PROTOCOL WOULD BE IN D-REPO
protocol RoutingLocalDataSourceProtocol {
    
    static func getFirstRunStatus(completion : @escaping(Bool) -> Void)
    static func setFirstRunFalse(completion : @escaping() -> Void)
    
}

class RoutingLocalDataSource: RoutingLocalDataSourceProtocol {
    
    enum RoutingString: String {
        case firstRun = "firstRun"
    }
    
    static func getFirstRunStatus(completion: @escaping (Bool) -> Void) {
        
        let defaults = UserDefaults.standard
        let status = defaults.bool(forKey: RoutingString.firstRun.rawValue)
        completion(!status)
    }
    
    static func setFirstRunFalse(completion: @escaping () -> Void) {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: RoutingString.firstRun.rawValue)
        completion()
    }

}
