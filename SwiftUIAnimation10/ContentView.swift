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
    @GestureState var drag: CGSize = .zero
    @State var dragOffset: CGSize = .zero
    @State var selectedHexes: Set<HexData> = []
    @State var touchedHexagon: HexData? = nil
    
    var body: some View {
        VStack {
            Text("Pick 5 or more")
            Text("\(touchedHexagon != nil ? "touched" : "released")")
            GeometryReader { proxy in
                HoneycombGrid(hexes: hexes) {
                    ForEach(hexes, id: \.self) { hex in
                        let hexOrNeighbor = touchedHexagon == hex || touchedHexagon?.hex.isNeighbor(of: hex.hex) == true
                        let m = measurement(for: hex, proxy)
                        let scale = (hexOrNeighbor ? 0.9 * m.size : m.size) / diameter
                        HexView(hex: hex,
                                isSelected: selectedHexes.contains(hex),
                                touchedHexagon: $touchedHexagon) {
                            select(hex: hex)
                        }
                                .transition(.scale)
                                .scaleEffect(max(0.001, scale))
                                .offset(.init(width: m.shift.x, height: m.shift.x))
                    }
                }
                .animation(.spring(), value: hexes)
                .offset(.init(width: drag.width + dragOffset.width,
                              height: drag.height + dragOffset.height))
                .onAppear {
                    hexes = HexData.hexes(for: topics)
                }
                .simultaneousGesture(DragGesture()
                    .updating($drag) { value, state, _ in
                        state = value.translation
                    }
                    .onEnded{ state in
                        onDragEnded(with: state)
                    }
                )
            }
            Text(selectedHexes.count < 5 ? "Pick \(5 - selectedHexes.count) more!" : "You're all set!")
            ProgressView(
                value: Double(min(5, selectedHexes.count)),
                total: 5
            )
            .scaleEffect(y: 3)
            .tint(selectedHexes.count < 5 ? .purple : .green)
            .padding(24)
            .animation(.easeInOut, value: selectedHexes.count)
        }
        .padding()
    }
    
    private func measurement(for hex: HexData, _ proxy: GeometryProxy) -> (size: CGFloat, shift: CGPoint) {
        let ox = hex.center.x + drag.width + dragOffset.width
        let oy = hex.center.y + drag.height + dragOffset.height
        let frame: CGRect = proxy.frame(in: .global)
        let ex = abs(ox) + diameter - frame.width / 2.0
        let ey = abs(oy) + diameter - frame.height / 2.0
        let excess = max(0, max(ex, ey))
        let size = max(0, diameter - excess * 3.0 / 4.0)
        
        let shift = CGPoint(
            x: ox > 0 ? -max(0, ex) / 3.0 : max(0, ex) / 3.0,
            y: oy > 0 ? -max(0, ey) / 3.0 : max(0, ey) / 3.0
                )
        return (size, shift)
    }
    
    private func select(hex: HexData) {
        if selectedHexes.contains(hex) {
            selectedHexes.remove(hex)
        }
        else {
            if selectedHexes.count < 5 {
                selectedHexes.insert(hex)
                appendHexesIfNeeded(for: hex)
            }
        }
        DispatchQueue.main.async {
        withAnimation(.spring()) {
            dragOffset = CGSize(width: -hex.center.x, height: -hex.center.y)
        }
        }
    }
    
    private func onDragEnded(with state: DragGesture.Value) {
        dragOffset = CGSize(
            width: dragOffset.width + state.translation.width,
            height: dragOffset.height + state.translation.height)
        let initialOffset = dragOffset
        var endX = initialOffset.width + state.predictedEndTranslation.width * 1.25
        var endY = initialOffset.height + state.predictedEndTranslation.height * 1.25
        let lastHex = hexes.last?.center ?? .zero
        let maxDistance = sqrt(pow(lastHex.x, 2) + pow(lastHex.y, 2)) * 0.7
        if abs(endX) > maxDistance {
            endX = endX > 0 ? maxDistance : -maxDistance
        }
        if abs(endY) > maxDistance {
            endY = endY > 0 ? maxDistance : -maxDistance
        }
        withAnimation(.spring()) {
            dragOffset = CGSize(width: endX, height: endY)
        }
    }
    private func appendHexesIfNeeded(for hex: HexData) {
        let shouldAppend = !hex.topic.contains("subtopic") && !hexes.contains(where: { $0.topic.contains("\(hex.topic)'s subtopic")})
        if shouldAppend {
            hexes.append(contentsOf: HexData.hexes(from: hex.hex, hexes, topics: [
                "\(hex.topic)'s subtopic 1",
                "\(hex.topic)'s subtopic 2",
                "\(hex.topic)'s subtopic 3",
            ]))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
