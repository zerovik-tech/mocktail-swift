//
//  VerticalPlanCard.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 10/12/23.
//

import SwiftUI

struct VerticalPlanCard: View {
    
    
    var plan: SubscriptionPlan
    var selectedPlan: SubscriptionPlan
    var title: String
    var titleTrial: String
    var trialOffer: String
    var localizedPrice:  String  {
        plan.localizedPrice
    }
    
    var isActive:Bool {
        (plan.identifier == selectedPlan.identifier)
    }
    
    var body: some View {
        VStack{
            
            VStack{
                VStack {
                    
                    VStack{
                        
                        Text(title)
                            .foregroundColor(isActive ? .white : .gray)
                            .bold()
                            .font(.title2)
                            .padding(.top, 4)
                        Text(titleTrial)
                            .foregroundColor(isActive ? .white : .gray)
                            .bold()
                            .font(.headline)
                        //                            .scaledToFit()
                        //                                .minimumScaleFactor(0.01)
                        //                                .lineLimi .t(1)
                            .padding(.bottom, 4)
                        ////                            .scaledToFit()
                        //                            .font(.largeTitle)
                        //                            .lineLimit(1)
                        //                            .padding(.horizontal)
                        //                            .padding(.top, 16)
                        //                            .minimumScaleFactor(0.01)
                        
                        //                        Text(titleTrial)
                        //                            .foregroundColor(isActive ? .white : nil)
                        //                            .bold()
                        //                            .scaledToFit()
                        //                            .font(.largeTitle)
                        //                            .padding(.horizontal)
                        //                            .padding(.bottom, 16)
                        //                            .minimumScaleFactor(0.01)
                        
                        //                        .font(.system(size: 24))
                        
                        //                    Text(titleTrial)
                        //                        .foregroundColor(isActive ? .white : nil)
                        //                        .bold()
                        
                        
                    }
                    //                    .font(.system(size: 24))
                    ZStack{
                        Rectangle()
                            .fill(
                                isActive ? Color(red: 0, green: 22/255, blue: 224/255) : Color(red: 211/255, green: 211/255, blue: 211/255)
                            )
                            .frame(height: 30)
                            .shadow(color: Color.black, radius: isActive ? 2 : 0)
                        Text(trialOffer)
                            .foregroundColor(.white)
                            .bold()
                            .font(.title3)
                    }
                    
                    
                    
                    
                    VStack {
                        Text(localizedPrice)
                            .foregroundColor(isActive ? .white : .gray)
                            .bold()
                            .font(.title2)
                            .padding(.vertical, 4)
                    }
                    
                    
                }
                .frame(maxWidth: (isActive ? UIScreen.main.bounds.width * 0.3846153846 : UIScreen.main.bounds.width * 0.3076923077) - 16, minHeight: UIScreen.main.bounds.height * 0.224824356 )
                
                //            if isActive {
                //                VStack{
                //                    Image(systemName: "checkmark.circle.fill")
                //                        .foregroundColor(.white)
                //                        .font(.system(size: 24))
                //                }
                //            }
                
            }
            .background(
                isActive ?
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .circular
                )
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            
                            colors: [Color(red: 255/255, green: 0, blue: 153/255, opacity: 0.84), Color(red: 82/255, green: 39/255, blue: 255/255, opacity: 0.50)]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                :
                    nil
            )
            .overlay(
                isActive ?
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 0, green: 22/255, blue: 224/255), lineWidth: 4)
                :
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(red: 211/255, green: 211/255, blue: 211/255), lineWidth: 4)
            )
            
            
        }
    }
}

//#Preview {
//    VerticalPlanCard(plan: SubscriptionPlan(identifier: "fk_499_1y_7d0", name: "Annual", isTrialEligible: true, localizedPrice: "$49.99"), selectedPlan: SubscriptionPlan(identifier: "fk_499_1y_7d0", name: "Annual", isTrialEligible: true, localizedPrice: "$49.99"), title: "Annual", titleTrial: "(7 day Free)", trialOffer: "SAVE 48%")
//}
