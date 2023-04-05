//
//  HexView.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import SwiftUI

struct HexView: View {
    let hex: HexData
    let isSelected: Bool
    @Binding var touchedHexagon: HexData?
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? .green : .purple)
                .overlay(
                    Circle()
                        .fill(touchedHexagon == hex ? .black.opacity(0.25) : .clear)
                )
                .onTapGesture {
                    onTap()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                touchedHexagon = hex
                            }
                        })
                        .onEnded({ _ in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                touchedHexagon = nil
                            }
                        })
                )
            Text(hex.topic)
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(4)
        }
        .shadow(radius: 4)
        .padding(4)
        .frame(width: diameter, height: diameter)
    }
}

struct HexView_Previews: PreviewProvider {
    static var previews: some View {
        HexView(hex: HexData(hex: .zero, center: .zero, topic: "Hello"), isSelected: true, touchedHexagon: .constant(nil)) {
        }
    }
}
