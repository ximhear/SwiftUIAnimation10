//
//  HoneycombGrid.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import SwiftUI

struct HoneycombGrid: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: proposal.width ?? .infinity, height: proposal.height ?? .infinity)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.enumerated().forEach { i, subview in
            let hexagon = hexes[i]
            let position = CGPoint(
                x: bounds.origin.x + hexagon.center.x + bounds.width / 2.0,
                y: bounds.origin.y + hexagon.center.y + bounds.height / 2.0)
            subview.place(at: position, anchor: .center, proposal: proposal)
        }
    }
    
    let hexes: [HexData]
}

struct HoneycombGrid_Previews: PreviewProvider {
    static var previews: some View {
        HoneycombGrid(hexes: HexData.hexes(for: ["Hello"])) {
            ForEach(HexData.hexes(for: ["Hello"]), id: \.self) { hex in
                HexView(hex: hex, isSelected: true, touchedHexagon: .constant(nil)) {
                }
            }
        }
    }
}
