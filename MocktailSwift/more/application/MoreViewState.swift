//
//  MoreViewState.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation


enum MoreViewState {
    struct ViewState{
        var more : More = More.empty()
        var isLoading: Bool = false
        var daysFirstRun : Bool = false
    }
    
    enum Action {
        case setMore(moreType : MoreType)
        
        case updateDailyLimit(to : Int)
        
        case getMore
        
        case checkDaysFirstRun
              
    }
    
    enum Result {
        case success(More)
    }
}
