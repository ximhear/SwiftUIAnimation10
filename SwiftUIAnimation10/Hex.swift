//
//  Hex.swift
//  SwiftUIAnimation10
//
//  Created by gzonelee on 2023/04/05.
//

import Foundation

struct Hex: Equatable {
    let q, r: Int
    var s: Int { -q - r }
    
    func center() -> CGPoint {
        let qVector = CGVector(dx: 3.0 / 2.0, dy: sqrt(3) / 2.0)
        let rVector = CGVector(dx: 0, dy: sqrt(3))
        let size = diameter / sqrt(3.0)
        let x = size * qVector.dx * Double(q)
        let y = size * (qVector.dy * Double(q) + rVector.dy * Double(r))
        return .init(x: x, y: y)
    }
}

extension Hex: AdditiveArithmetic {
    static func - (lhs: Hex, rhs: Hex) -> Hex {
        .init(q: lhs.q - rhs.q, r: lhs.r - rhs.r)
    }
    
    static func + (lhs: Hex, rhs: Hex) -> Hex {
        .init(q: lhs.q + rhs.q, r: lhs.r + rhs.r)
    }
    
    static var zero: Hex {
        .init(q: 0, r: 0)
    }
}

extension Hex {
    enum Direction: CaseIterable {
        case bottomRight
        case bottom
        case bottomLeft
        case topLeft
        case top
        case topRight
        
        var hex: Hex {
            switch self {
            case .top:
                return .init(q: 0, r: -1)
            case .topRight:
                return .init(q: 1, r: -1)
            case .bottomRight:
                return .init(q: 1, r: 0)
            case .bottom:
                return .init(q: 0, r: 1)
            case .bottomLeft:
                return .init(q: -1, r: 1)
            case .topLeft:
                return .init(q: -1, r: 0)
            }
        }
    }
    
    func neighbor(at direction: Direction) -> Hex {
        self + direction.hex
    }
    
    func isNeighbor(of hex: Hex) -> Bool {
        Direction.allCases.contains { hex.neighbor(at: $0) == hex }
    }
}
