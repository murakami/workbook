//
//  Employee.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2025/02/13.
//

import Foundation

class Employee: NSObject, Identifiable {
    let id = UUID()
    var name: String = "New Employee"
    var raise: Float = 0.05
}
