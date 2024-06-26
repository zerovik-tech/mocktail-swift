//
//  MoreViewModel.swift
//  MocktailSwift
//
//  Created by Karan Chilwal on 26/06/24.
//

import Foundation


class MoreViewModel : ObservableObject {
    @Published var viewState : MoreViewState.ViewState
    private let interactor : MoreViewInteractorProtocol
    init(interactor: MoreViewInteractorProtocol) {
        self.interactor = interactor
        self.viewState = MoreViewState.ViewState()
    }
    
    func send(action: MoreViewState.Action) {
        
        switch action {
            
        case .setMore(moreType: let moreType):
            setMore(moreType: moreType)
        case .updateDailyLimit(to: let to):
            updateDailyLimit(to: to)
        case .getMore:
            getMore()
        case .checkDaysFirstRun:
            checkDaysFirstRun()
        }
        
    }
  
    
    private func checkDaysFirstRun(){
        interactor.checkDaysFirstRun { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                viewState.daysFirstRun = result
            }
        }
    }
    
    private func setMore(moreType: MoreType) {
        interactor.setMore(more: viewState.more, setMoreType: moreType) { _ in }
    }
    
    private func updateDailyLimit(to : Int){
        viewState.more.dailyFreeLimit = to
    }
    
    private func getMore() {
        interactor.getMore { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                    
                case .success(let more):
                    self.viewState.more = more
                }
            }
        }
    }


}
