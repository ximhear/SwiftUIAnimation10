//
//  ContentView.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import SwiftUI

let diameter = 125.0

struct ContentView: View {
    @State var hexes: [HexData] = []
    private let topics = [
        "Politics",
        "Science",
        "Animals",
        "Plants",
        "Tech",
        "Music",
        "Sports",
        "Books",
        "Cooking",
        "Traveling",
        "TV-series",
        "Art",
        "Finance",
        "Fashion"
    ]
    var body: some View {
        VStack {
            Text("Pick 5 or more")
            HoneycombGrid(hexes: hexes) {
                ForEach(hexes, id: \.self) { hex in
                    HexView(hex: hex)
                }
            }
        }
        .padding()
        .onAppear {
            hexes = HexData.hexes(for: topics)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
