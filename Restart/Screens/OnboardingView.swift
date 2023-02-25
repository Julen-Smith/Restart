//
//  OnboardingView.swift
//  Restart
//
//  Created by Julen Smith on 21/2/23.
//

import SwiftUI

struct OnboardingView: View {
    //Propiedades
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating : Bool = false
    @State private var imageOffSet : CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle : String = "Animación"
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    //Cuerpo
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing : 20)
            {
            // - HEADER
                Spacer()
                VStack(spacing: 0){
                Text(textTitle)
                    .font(.system(size: 60))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .transition(.opacity)
                    .id(textTitle)
                
                Text("""
                Aplicación para conocer componentes reutilizables, parallax, animaciones y efectos de sonido en SwiftUI
                """)
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            }
                .opacity(isAnimating ? 1: 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                //HEADER
                // - CENTER
                ZStack{
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffSet.width * -1)
                        .blur(radius: abs(imageOffSet.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffSet)
                    
                    Image("walle")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1:0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffSet.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffSet.width / 20)))
                        .gesture(
                        DragGesture()
                            .onChanged
                        {
                            gesture in
                            if abs(imageOffSet.width) <= 150
                            {
                                imageOffSet = gesture.translation
                                
                                withAnimation(.linear(duration: 0.25))
                                {
                                    indicatorOpacity = 0
                                    textTitle = "Parallax"
                                }
                            }
                        }
                            .onEnded
                        {
                            _ in
                            imageOffSet = .zero
                            withAnimation(.linear(duration: 0.25))
                            {
                                indicatorOpacity = 1
                                textTitle = "Animación"
                            }
                        }
                        )
                        .animation(.easeOut(duration: 1), value: imageOffSet)
                }
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size:44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration :1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                        , alignment: .bottom
                )
                //CENTER
                Spacer()
              // - FOOTER
                ZStack
                {
                    //Partes del botón custom
                    //1- Bg static
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    
                    //2- Call to action
                        Text("Siguiente")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    //3 - Capsula dinamica
                    //Se utiliza un HStack de cara a poder utilizar el espacio horizontal para la movilidad del botón al final no dejan de ser layers
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }
                    
                    //4 - Circulo util
                    HStack {
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                            
                        }
                        .foregroundColor(.white)
                    .frame(width: 80, height: 80, alignment: .center)
                    .offset(x: buttonOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80
                                {
                                    buttonOffset = gesture.translation.width
                                }
                            }
                            .onEnded{ _ in
                                withAnimation(Animation.easeOut(duration: 0.4)){
                                    if buttonOffset > buttonWidth / 2
                                    {
                                        hapticFeedback
                                            .notificationOccurred(.success)
                                        playSound(sound: "chimeup", type: "mp3")
                                        buttonOffset = buttonWidth - 80
                                        isOnboardingViewActive = false
                                    }
                                    else
                                    {
                                        hapticFeedback.notificationOccurred(.warning)
                                        buttonOffset = 0
                                    }
                                }
                            }
                    ) //Gesture
                        Spacer()
                    }//HSTACK
                    
                } //Footer
                .frame(width: buttonWidth, height:80, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1:0)
                .offset(y: isAnimating ? 0:40)
                .animation(.easeOut(duration:1), value: isAnimating)
                
                
            }// VSTACK
        } // ZSTACK
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
