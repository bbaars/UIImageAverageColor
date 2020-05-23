//
//  ContentView.swift
//  BackgroundGradient
//
//  Created by Brandon Baars on 5/18/20.
//  Copyright © 2020 Brandon Baars. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor: Color = .clear
    @State private var currentIndex = 0

    // Scale Gesture
    @State private var currentAmount: CGFloat = 0
    @State private var finalAmount: CGFloat = 1

    // Drag Gesture
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @GestureState private var dragOffset = CGSize.zero

    private var images: [String] = ["background0",
                                   "background1",
                                   "background2",
                                   "background3",
                                   "background4",
                                   "background5",
                                   "background6"]
    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
       let dragGesture =
        DragGesture()
            .updating($dragOffset) { (value, state, transaction) in
                state = value.translation
            }
            .onEnded { (value) in
                self.offset.height += value.translation.height
                self.offset.width += value.translation.width
            }

        let scaleGesture =
            MagnificationGesture()
                .onChanged { amount in
                    self.currentAmount = amount - 1
                }
                .onEnded { amount in
                    self.finalAmount += self.currentAmount
                    self.currentAmount = 0
                }

        return GeometryReader { geometry in
            Image(self.images[self.currentIndex])
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 10)
                .offset(x: self.offset.width + self.dragOffset.width,
                        y: self.offset.height + self.dragOffset.height)
                .scaleEffect(self.currentAmount + self.finalAmount)
                .onTapGesture {
                    if (self.currentIndex == self.images.count - 1) {
                        self.currentIndex = 0
                    } else {
                        self.currentIndex = min(self.currentIndex + 1, self.images.count - 1)
                    }

                    self.setAverageColor()
                }
                .gesture(dragGesture)
                .gesture(scaleGesture)
        }
        .background(backgroundColor)
        .onAppear {
            self.setAverageColor()
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func setAverageColor() {
        let uiColor = UIImage(named: images[currentIndex])?.averageColor ?? .clear
        backgroundColor = Color(uiColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
