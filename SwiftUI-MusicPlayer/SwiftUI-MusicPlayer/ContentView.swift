//
//  ContentView.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/3/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let topGradientColor = Color("BackgroundGradientTop")
    let bottomGradientColor = Color("BackgroundGradientBottom")
    let buttonColor = Color("Button")
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [topGradientColor, bottomGradientColor]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            // Top navigation bar
            VStack {
                Button(action: {
                    // TODO: Add back navigation action
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(buttonColor)
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
