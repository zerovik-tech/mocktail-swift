//
//  TempView.swift
//  Mocktail
//
//  Created by Sachin Pandey on 12/07/24.
//

import SwiftUI

struct TempView: View {
    @State private var change = false
    var body: some View {
        VStack{
            GeometryReader { geo in
                
                Rectangle()
                    .fill(change ? .green : .red)
                    .frame(width: 200)
                    .overlay(content: {
                        Text("width: \(geo.size.width), height: \(geo.size.height)")
                    })
                    .onTapGesture{
                        change.toggle()
                        print("width: \(geo.size.width), height: \(geo.size.height)")
                    }
                
                
                    .background(.green)
                
            }
        }
        .frame(width: 400, height: 500)
    }
}

#Preview {
    TempView()
}
