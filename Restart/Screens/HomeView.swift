//
//  HomeView.swift
//  Restart
//
//  Created by Julen Smith on 21/2/23.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = false
    @State private var isAnimating: Bool = false
    
    
    var body: some View {
        VStack(spacing:20) {
            //HEADER
            Spacer()
            ZStack {
                CircleGroupView(ShapeColor: .gray, ShapeOpacity: 0.1)
                Image("eva")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 35 : -35)
                    .animation(
                        Animation
                            .easeInOut(duration: 4)
                            .repeatForever()
                        ,value: isAnimating
                    )
            }
            
            //CENTER
            
            Text("Es imposible no progresar en cualquier cosa, cuando le dedicas tiempo.")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            
            //FOOTER
            
            Spacer()
            
            Button(action:{
                withAnimation{
                    playSound(sound: "success", type: "m4a")
                    isOnboardingViewActive = true;
                }
            }){
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large)
                
                Text("Restart")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }//boton
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            
        } //VSTACK
        .onAppear(perform:{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute:{
                isAnimating = true
            })
        })
        .preferredColorScheme(.light)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
