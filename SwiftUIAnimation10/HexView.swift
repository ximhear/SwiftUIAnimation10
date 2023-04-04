//
//  HexView.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import SwiftUI

struct HexView: View {
    let hex: HexData
    var body: some View {
        ZStack {
            Circle()
                .fill(.purple)
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
        HexView(hex: HexData(hex: .zero, center: .zero, topic: "Hello"))
    }
}
