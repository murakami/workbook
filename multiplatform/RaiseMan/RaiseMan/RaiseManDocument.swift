//
//  RaiseManDocument.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2025/02/10.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleData: UTType {
        UTType(importedAs: "com.example.rmedata")
    }
}

struct RaiseManDocument: FileDocument {
    //var text: String
    var employees: [Employee] = []

    /*
    init(text: String = "Hello, world!") {
        self.text = text
    }
     */
    init() {
        self.employees = []
    }

    static var readableContentTypes: [UTType] { [.exampleData] }

    init(configuration: ReadConfiguration) throws {
        /*
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
         */
        guard let data = configuration.file.regularFileContents,
              let list = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [], from: data) as? [Employee]
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        employees = list
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        /*
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
         */
        let data = try? NSKeyedArchiver.archivedData(withRootObject: employees, requiringSecureCoding: false)
        return .init(regularFileWithContents: data ?? Data())
    }
}
