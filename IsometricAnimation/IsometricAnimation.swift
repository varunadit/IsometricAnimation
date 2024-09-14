//
//  IsometricAnimation.swift
//  IsometricAnimation
//
//  Created by Varun Adit on 9/14/24.
//

import SwiftUI
struct IsometricAnimation: View {
    @State var animateLogo1: Bool = false
    @State var animateLogo2: Bool = false
    @State var animateLogo3: Bool = false
    @State var animateLogo4: Bool = false
    var body: some View {
        ZStack {
            Color.pink
                .ignoresSafeArea()
            
            HStack(spacing: -5){
                VStack(spacing: -5){
                    IsometricView(isGrowing: $animateLogo1){
                        ZStack {
                            Color.blue
                            Color.pink
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    } bottom: {
                        Color.blue
                    } side: {
                        Color.blue
                    }
                    .frame(width: 100, height: 100)
                    IsometricView(isGrowing: $animateLogo2) {
                        ZStack {
                            Color.blue
                            Color.pink
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    } bottom: {
                        Color.blue
                    } side: {
                        Color.blue
                    }
                    .frame(width: 100, height: 100)
                }
                VStack(spacing: -5){
                    IsometricView(isGrowing: $animateLogo3) {
                        ZStack {
                            Color.blue
                            Color.pink
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    } bottom: {
                        Color.blue
                    } side: {
                        Color.blue
                    }
                    .frame(width: 100, height: 100)
                    IsometricView(isGrowing: $animateLogo4) {
                        ZStack {
                            Color.blue
                            Color.pink
                                .padding(5)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    } bottom: {
                        Color.blue
                    } side: {
                        Color.blue
                    }
                    .frame(width: 100, height: 100)
                }
            }
            .projectionEffect(.init(.init(1, 0.04, 0, 1, 0, 0)))

        }
        .onAppear{
            animateLogo1.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animateLogo4.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                animateLogo2.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                animateLogo3.toggle()
            }
            
        }

    }
}

struct IsometricView<Content: View, Bottom: View, Side: View>: View {
    var content: Content
    var bottom: Bottom
    var side: Side
    @Binding private var isGrowing: Bool

    
    init(isGrowing: Binding<Bool>, depth: CGFloat = 10, @ViewBuilder content: @escaping () -> Content, @ViewBuilder bottom: @escaping () ->Bottom, @ViewBuilder side: @escaping () -> Side) {
        self.content = content()
        self.bottom = bottom()
        self.side = side()
        self._isGrowing = isGrowing
    }
    
    var body: some View {
        Color.clear
            .overlay {
                GeometryReader { geometry in
                    ZStack {
                        content
                        DepthView(isBottom: true, size: geometry.size)
                        DepthView(size: geometry.size)
                        
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: isGrowing ? 0 : -50, y: isGrowing ? 0 : -50)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true),
                        value: isGrowing
                    )
                }
            }
    }
    
    @ViewBuilder
    func DepthView(isBottom: Bool = false, size: CGSize) -> some View {
        ZStack {
            if isBottom {
                bottom
                    .frame(height: isGrowing ? 0 :  50)
                    .projectionEffect(.init(.init(1, 0, 1, 1, 0, 0)))
                    .offset(y: isGrowing ? 0 : 50)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                side
                    .frame(width: isGrowing ? 0 : 50)
                    .projectionEffect(.init(.init(1, 1, 0, 1, 0, 0)))
                    .offset(x: isGrowing ? 0 : 50)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .animation(
            Animation.easeInOut(duration: 0.6)
                .repeatForever(autoreverses: true),
            value: isGrowing
        )
    }
}

#Preview(body: {
    IsometricAnimation()
})
