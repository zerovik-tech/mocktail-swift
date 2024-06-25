//
//  AmplitudeManager.swift
//  Hashtag Generator Pro
//
//  Created by Karan Chilwal on 14/06/24.
//

import Foundation
import AmplitudeSwift

class AmplitudeManager {
    
   static let amplitude = Amplitude(configuration: Configuration(
        apiKey: AMPLITUDE_API_KEY
    ))
}
