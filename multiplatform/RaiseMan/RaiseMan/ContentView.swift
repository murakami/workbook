//
//  ContentView.swift
//  RaiseMan
//
//  Created by 村上幸雄 on 2025/02/10.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: RaiseManDocument
    @State private var sortOrder = [KeyPathComparator(\Employee.name)]
    let percentStyle = FloatingPointFormatStyle<Float>.Percent.percent

    var body: some View {
        HStack {
            Table(document.employees, sortOrder: $sortOrder) {
                TableColumn("Name", value: \.name)
                TableColumn("Raise", value: \.raise) { employee in
                    Text(employee.raise, format: percentStyle)
                }
            }
            .onChange(of: sortOrder, initial: true) { _, sortOrder in
                document.employees.sort(using: sortOrder)
            }
            VStack {
                Button("Add Employee") {
                    document.employees.append(Employee())
                }
                Button("Remove") {
                }
                Spacer()
            }
            .padding()
        }.padding()
    }
}

#Preview {
    ContentView(document: .constant(RaiseManDocument()))
}
