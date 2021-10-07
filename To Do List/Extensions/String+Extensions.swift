//
//  String+Extensions.swift
//  To Do List
//
//  Created by Evgeniy Goncharov on 01.10.2021.
//

// New properties for String, replace small sumbol 
extension String {
    var capitilizedWithSpaces: String {
        let withSpace = reduce("") { result, character in
            character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
        }
        
        return withSpace.capitalized
    }
}
