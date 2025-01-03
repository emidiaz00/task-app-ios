//
//  ContentView.swift
//  task-app-ios
//
//  Created by Emiliano Diaz on 30/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TaskListView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
