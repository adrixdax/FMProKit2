//
//  File.swift
//  
//
//  Created by Adriano d'Alessandro on 17/06/24.
//

import Foundation

public func getElementTypeName<T>(of value: T) -> String {
    let mirror = Mirror(reflecting: value)
    if let displayStyle = mirror.displayStyle {
        switch displayStyle {
        case .collection, .set, .dictionary:
            if let firstChild = mirror.children.first {
                return String(describing: type(of: firstChild.value))
            }
        default:
            break
        }
    }
    let typeDescription = String(describing: T.self)
    if let range = typeDescription.range(of: "<.*>", options: .regularExpression) {
        let genericType = typeDescription[range]
        return String(genericType.dropFirst().dropLast())
    }
    return typeDescription
}
