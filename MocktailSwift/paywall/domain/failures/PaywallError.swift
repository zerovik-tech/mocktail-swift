//
//  PaywallError.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation

enum PaywallError: Error {
    case failureReason(String)

    func failureReason(_ reason: String) -> PaywallError {
        return .failureReason(reason)
    }
}

