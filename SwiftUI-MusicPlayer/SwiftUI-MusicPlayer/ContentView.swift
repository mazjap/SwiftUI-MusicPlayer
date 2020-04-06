//
//  ContentView.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/3/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    let apiController = APIController()
    let impact = UIImpactFeedbackGenerator()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    // Top navigation bar
                    HStack {
                        BasicButton(size: geometry.size.width * 0.075, imageName: "arrow.left", completion: { // Back button
                            self.impact.impactOccurred()
                        })
                        
                        Spacer()
                        
                        Text("Playing Now")
                            .font(Font.system(.headline).smallCaps())
                            
                            .foregroundColor(.buttonColor)
                        
                        Spacer()
                        
                        BasicButton(size: geometry.size.width * 0.075, imageName: "line.horizontal.3", completion: { // Song list
                            self.impact.impactOccurred()
                        })
                    }
                    .padding(.horizontal, 36)
                    .padding(.top, 16)
                    
                    Spacer()
                    
                    Artwork(size: geometry.size.width * 0.8, apiController: self.apiController)
                    
                    Spacer()
                    
                    // Song navigation
                    HStack {
                        BasicButton(size: geometry.size.width * 0.1, imageName: "backward.fill", color: Color.white, completion: { // Skip backward
                            self.impact.impactOccurred()
                            self.apiController.goBackSong()
                        })
                        
                        Spacer()
                        
                        PlayPauseButton(size: geometry.size.width * 0.115, apiController: self.apiController, completion: { // Play and Pause
                            self.impact.impactOccurred()
                        })
                        
                        Spacer()
                        
                        BasicButton(size: geometry.size.width * 0.1, imageName: "forward.fill", color: Color.white, completion: { // Skip forward
                            self.impact.impactOccurred()
                            self.apiController.skipSong()
                        })
                    }
                    .padding(.horizontal, 36)
                    .padding(.bottom, 16)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.colorScheme, .dark)
    }
}

struct PlayPauseButton: View {
    
    @State var isPlaying: Bool = true
    let width: CGFloat
    let height: CGFloat
    let apiController: APIController
    let completion: () -> Void
    
    init(size: CGFloat, apiController: APIController, completion: @escaping () -> Void) {
        self.width = size
        self.height = size
        self.apiController = apiController
        self.completion = completion
        
        isPlaying = apiController.isPlaying()
    }
    
    var body: some View {
        Button(action: {
            self.completion()
            self.isPlaying.toggle()
            self.apiController.playPause(bool: self.isPlaying)
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: colorForIsPlaying()), startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                    .frame(width: width * 2, height: height * 2)
                    .shadow(color: Color.black.opacity(0.45), radius: 10, x: 10, y: 10)
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -5, y: -5)
                
                Image(systemName: isPlaying ? "pause" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .font(Font.system(.headline).weight(.heavy))
                    .foregroundColor(.white)
                    .frame(width: width / 2, height: height / 2)
                    .padding(.all, (width - 10) * 0.8)
                    .background(LinearGradient(gradient: Gradient(colors: colorForIsPlaying()), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all))
                    .clipShape(Circle())
            }
        }
    }
    
    func colorForIsPlaying() -> [Color] {
        return isPlaying ? [.pauseButtonLightColor, .pauseButtonDarkColor] : [.playButtonLightColor, .playButtonDarkColor]
    }
}

struct BasicButton: View {
    
    let width: CGFloat
    let height: CGFloat
    let imageName: String
    let color: Color
    let completion: () -> Void
    
    init(size: CGFloat, imageName: String, color: Color = .buttonColor, completion: @escaping () -> Void) {
        self.width = size
        self.height = size
        self.imageName = imageName
        self.color = color
        self.completion = completion
    }
    
    var body: some View {
        Button(action: {
            self.completion()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .bottomTrailing, endPoint: .topLeading)
                )
                    .frame(width: width * 2, height: height * 2)
                    .shadow(color: Color.black.opacity(0.45), radius: 12, x: 8, y: 8)
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -3, y: -3)
                
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

struct Artwork: View {
    
    @ObservedObject var song: Song
    
    let width: CGFloat
    let height: CGFloat
    let apiController: APIController
    
    init(size: CGFloat, song: Song = Song(albumTitle: "Wut?", artistName: "Future ft. The Weekend", songTitle: "Low Life", songId: 2), apiController: APIController) {
        self.width = size
        self.height = size
        self.song = song
        self.apiController = apiController
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.bottomGradientColor.opacity(0.75))
                    .frame(width: width * 1.075, height: width * 1.075)
                    .shadow(color: Color.black.opacity(0.4), radius: 25, x: 25, y: 25)
                    .shadow(color: Color.white.opacity(0.1), radius: 15, x: -15, y: -15)
                
                Image(uiImage: song.artwork)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .font(Font.system(.headline).weight(.bold))
                    .foregroundColor(.buttonColor)
                    .frame(width: width, height: width)
                    .background(LinearGradient(gradient: Gradient(colors: [.topGradientColor, .bottomGradientColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all))
                    .clipShape(Circle())
            }
            
            VStack {
                Text(song.title)
                    .font(Font.system(.largeTitle, design: .rounded).weight(.medium))
                    .foregroundColor(Color.white.opacity(0.6))
                
                Text(song.artistName)
                    .font(Font.system(.body, design: .rounded))
                    .foregroundColor(Color.buttonColor)
            }
            
            SliderView(song: song, apiController: apiController)
        }
    }
}

struct SliderView: View {
    
    @ObservedObject var song: Song
    
    var trackRadius: CGFloat = 3
    let apiController: APIController
    
    var body: some View {
        VStack {
            HStack {
                Text("\(apiController.getTotalTime())")
                
                Spacer()
                
                Text("\(apiController.getCurrentTime())")
            }
            .foregroundColor(Color.buttonColor)
            .font(Font.system(.caption))
            
            ZStack {
                RoundedRectangle(cornerRadius: trackRadius)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.topGradientColor, .black]), startPoint: .bottom, endPoint: .top)
                    )
                    .frame(height: trackRadius * 2)
                
                GeometryReader { geometry in
                    HStack {
                        RoundedRectangle(cornerRadius: self.trackRadius)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.pauseButtonDarkColor, .trackYellowColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                            .frame(width: geometry.size.width * self.percentCompleteForSong(), height: self.trackRadius * 2)
                        Spacer()
                    }
                }
                GeometryReader { geometry in
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(
                                    RadialGradient(gradient: Gradient(colors: [ .topGradientColor, .bottomGradientColor, .black]), center: .center, startRadius: 0, endRadius: 20), lineWidth: 12)
                                .frame(width: self.trackRadius * 6.25, height: self.trackRadius * 6.25)
                        }
                        .padding(.leading, geometry.size.width * self.percentCompleteForSong() - self.trackRadius * 3.25 - 13 / 2)
                        Spacer()
                    }
                    
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    func getMinutes(time: TimeInterval) -> String {
        return "\(Int(time / 60))"
    }
    
    func getSeconds(time: TimeInterval) -> String {
        var seconds = "\(Int(time.truncatingRemainder(dividingBy: 60)))"
        if seconds.count == 1 {
            seconds += "0"
        }
        
        return seconds
    }
    
    func percentCompleteForSong() -> CGFloat {
        return 0.1
//        return CGFloat(song.currentTime / song.duration)
    }
}
