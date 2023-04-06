//
//  HexData.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import Foundation

struct HexData: Hashable {
    var hex: Hex
    var center: CGPoint
    var topic: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(topic)
    }
    
    static func hexes(for topics: [String]) -> [Self] {
        var ringIndex = 0
        var currentHex = Hex(q: 0, r: 0)
        var hexes = [Hex(q: 0, r: 0)]
        let directions = Hex.Direction.allCases.enumerated()
        repeat {
            directions.forEach { index, direction in
                let smallerSegment = index == 1
                let segmentSize = smallerSegment ? ringIndex : ringIndex + 1
                for _ in 0..<segmentSize {
                    guard hexes.count != topics.count else { break }
                    currentHex = currentHex + direction.hex
                    hexes.append(currentHex)
                }
            }
            ringIndex += 1
        } while hexes.count < topics.count
        return hexes.enumerated().map { index, hex in
            HexData(hex: hex, center: hex.center(), topic: topics[index])
        }
    }
    static func hexes(from source: Hex, _ array: [HexData], topics: [String]) -> [HexData] {
        var newHexData: [HexData] = []
        
        for direction in Hex.Direction.allCases {
            let newHex = source.neighbor(at: direction)
            if !array.contains(where: { $0.hex == newHex }) {
                newHexData.append(HexData(hex: newHex, center: newHex.center(), topic: topics[newHexData.count]))
            }
            if newHexData.count == topics.count {
                return newHexData
            }
        }
        newHexData.append(contentsOf: hexes(from: source.neighbor(at: .allCases.randomElement()!), array + newHexData, topics: Array( topics.dropFirst(newHexData.count))))
        
        return newHexData
    }
}
