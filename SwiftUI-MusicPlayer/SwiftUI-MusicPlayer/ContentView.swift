//
//  ContentView.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/3/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            // Top navigation bar
            VStack {
                HStack {
                    BasicButton(width: 30, height: 30, imageName: "arrow.left")
                    
                    Spacer()
                    
                    Text("Song Name")
                        .font(Font.system(.headline).smallCaps())
                        
                        .foregroundColor(.buttonColor)
                    
                    Spacer()
                    
                    BasicButton(width: 30, height: 30, imageName: "line.horizontal.3")
                }
                .padding(.horizontal, 36)
                Spacer()
                
                HStack {
                    BasicButton(width: 42, height: 42, imageName: "backward.fill", color: Color.white)
                    
                    Spacer()
                    
                    PlayPauseButton()
                    
                    Spacer()
                    
                    BasicButton(width: 42, height: 42, imageName: "forward.fill", color: Color.white)
                }
                .padding(.horizontal, 36)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        .environment(\.colorScheme, .dark)
    }
}

struct PlayPauseButton: View {
    
    @State var isPlaying = true
    
    var body: some View {
        Button(action: {
            self.isPlaying.toggle()
        }) {
            ZStack {
                    Circle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.playButtonLightColor, .playButtonDarkColor]), startPoint: .bottomTrailing, endPoint: .topLeading)
                    )
                        .frame(width: 85, height: 85)
                        .shadow(color: Color.black.opacity(0.35), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.15), radius: 10, x: -5, y: -5)
                
                Image(systemName: isPlaying ? "pause" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(Font.system(.headline).weight(.heavy))
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .padding(.all, 28)
                    .background(LinearGradient(gradient: Gradient(colors: [.playButtonLightColor, .playButtonDarkColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all))
                    .clipShape(Circle())
            }
        }
    }
}

struct BasicButton: View {
    
    let width: CGFloat
    let height: CGFloat
    let imageName: String
    let color: Color
    
    init(width: CGFloat, height: CGFloat, imageName: String, color: Color = .buttonColor) {
        self.width = width
        self.height = height
        self.imageName = imageName
        self.color = color
    }
    
    var body: some View {
        Button(action: {
            // TODO: Add back navigation action
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                    .frame(width: width * 2, height: height * 2)
                    .shadow(color: Color.black.opacity(0.35), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -5, y: -5)
                
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(Font.system(.headline).weight(.bold))
                    .foregroundColor(color)
                    .frame(width: width, height: height)
                    .padding(.all, (width - 10) * 0.5)
                    .background(LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all))
                    .clipShape(Circle())
            }
        }
    }
}
