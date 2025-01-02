//
//  GeneratePassword.swift
//  RandomPassword
//
//  Created by 村上幸雄 on 2025/01/02.
//

import Foundation

private let characters = Array("0123456789abcdefghijklmnopqrstuvwxyz" +
                               "ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func generateRandomString(length: Int) -> String {
    // Start with an empty string
    var string = ""

    // Append 'length' number of random characters
    for _ in 0..<length {
        string.append(generateRandomCharacter())
    }

    return string
}

func generateRandomCharacter() -> Character {
    // Create a random index into the characters array
    let index = Int(arc4random_uniform(UInt32(characters.count)))

    // Get and return a random character
    let character = characters[index]
    return character
}
