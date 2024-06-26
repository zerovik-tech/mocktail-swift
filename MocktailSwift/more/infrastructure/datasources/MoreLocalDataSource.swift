//
//  MoreLocalDataSource.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation


protocol MoreLocalDataSourceProtocol {
    static func getMore(completion : @escaping (More) -> Void)
    static func setMore(more: More, setMoreType: MoreType, completion: @escaping () -> Void)
    static func checkDaysFirstRun(completion : @escaping (Bool) -> Void)
}

class MoreLocalDataSource : MoreLocalDataSourceProtocol {
  
 
    static func setMore(more: More, setMoreType: MoreType, completion: @escaping () -> Void) {
        
        let userDefaults = UserDefaults.standard
        
        switch setMoreType {
        case .dailyFreeLimit:
            userDefaults.set(more.dailyFreeLimit, forKey: MoreType.dailyFreeLimit.rawValue)
            
            return completion()
            
            
            
        }
    }
    
    static func getMore(completion: @escaping (More) -> Void) {
        let userDefaults = UserDefaults.standard
        
        let more = More(dailyFreeLimit: userDefaults.integer(forKey: MoreType.dailyFreeLimit.rawValue))
        return completion(more)
    }
    
    
    
    static func checkDaysFirstRun(completion: @escaping (Bool) -> Void) {
      
        let userDefaults = UserDefaults.standard
        let lastRun = userDefaults.object(forKey: lastRunDate) as? Date
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            if let lastRun = lastRun,
               calendar.isDate(currentDate, inSameDayAs: lastRun) {
                completion(false)
            } else {
                userDefaults.set(currentDate, forKey: lastRunDate)
                completion(true)
            }
        
    }

    
}
