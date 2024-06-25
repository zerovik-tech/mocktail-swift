//
//  SplashView.swift
//  Teleprompter
//
//  Created by Bhartendu Vimal Joshi on 01/07/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            VStack{
                Image("app_icon")
                    .resizable()
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                
//                Text("Teleprompter")
//                    .font(.system(size: 32))
//                    .bold()
//                    .padding(.bottom, 4)
            }
            Spacer()
            VStack(spacing: 4){
                Text("from")
                    .foregroundColor(.secondary)
                    .font(.footnote)
                Text("Zerovik")
                    .font(.custom("Lancelot", size: 24))
    //            Image("zerovik_icon")
    //                .resizable()
    //                .aspectRatio(contentMode: .fit)
    //                .frame(width: 50)
            }
        }
        .onAppear {
            let structName = String(describing: type(of: self))
            AmplitudeManager.amplitude.track(eventType : structName)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
