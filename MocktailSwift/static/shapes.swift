//
//  shapes.swift
//  Keys AI AI Keyboard
//
//  Created by Sachin Pandey on 16/02/24.
//

import SwiftUI
let appColor1: Color = Color(red: 0.87, green: 0.96, blue: 1.00, opacity: 1)
let appColor2: Color = Color(red: 0.00, green: 0.48, blue: 1.00)
//let appColor3: Color = Color(red: 0.27, green: 0.59, blue: 0.32)
let paywallButtonColor: Color = Color(red: 0.87, green: 0.96, blue: 1.00)
let languageCardColor = Color(red: 0.76, green: 0.90, blue: 0.97)
let lineColor = Color(red: 0.76, green: 0.54, blue: 0.54)
let textColor = Color(red: 0.31, green: 0.31, blue: 0.31)
let mic1Color = Color(red: 0.00, green: 0.63, blue: 0.89)
let mic2Color = Color(red: 0.63, green: 0.13, blue: 0.94)




let customLightGray: Color = Color(red: 0.93, green: 0.93, blue: 0.93)
let gradientColor1: Color = Color(red: 0.03, green: 0.72, blue: 0.55)
let gradientColor2: Color = Color(red: 0.00, green: 0.48, blue: 0.36)
let customGold: Color = Color(red: 0.71, green: 0.55, blue: 0.0)


struct Arc1: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX - rect.maxX / 3, y: rect.minY + rect.maxY / 12))
        path.addQuadCurve(to: CGPoint(x: rect.maxX + rect.maxX / 3, y: rect.minY + rect.maxY / 12 ), control: CGPoint(x: rect.midX, y: rect.midY - rect.maxY / 8))
        path.addLine(to: CGPoint(x: rect.maxX + 1, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX - 1, y: rect.maxY + 1))
        path.closeSubpath()
        return path
    }
    
    
}

struct Arc2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX - rect.maxX / 3, y: rect.minY + rect.maxY / 5))
        path.addQuadCurve(to: CGPoint(x: rect.maxX + rect.maxX / 3, y: rect.minY + rect.maxY / 5 ), control: CGPoint(x: rect.midX, y: rect.midY + rect.maxY / 16))
        path.addLine(to: CGPoint(x: rect.maxX + rect.maxX / 3, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX - rect.maxX / 3, y: rect.minY))
        path.closeSubpath()
        return path
    }
    
    
}

struct Arc3: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX , y: rect.maxY - rect.maxY / 2.5))
        path.addQuadCurve(to: CGPoint(x: rect.maxX , y: rect.maxY - rect.maxY / 2.5 ), control: CGPoint(x: rect.midX, y: rect.minY + rect.maxY / 1.9))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX , y: rect.maxY))
        path.closeSubpath()
        return path
    }
    
    
}

struct ConvexShape1: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            

            

            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.maxX - rect.maxX / 4, y: rect.maxY / 2))

            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX, y: rect.maxY / 2), radius: (rect.maxY - rect.minY) / 2 , startAngle: .degrees(90), endAngle: .degrees(270), clockwise: false)
            
          
            
            
        }
    }
}

struct ConvexShape2: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            

            

            path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            
            path.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY / 2), radius: (rect.maxY - rect.minY) / 2 , startAngle: .degrees(270), endAngle: .degrees(90), clockwise: false)
            path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.minX + rect.maxX / 4, y: rect.maxY / 2))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            
            
          
            
            
        }
    }
}

