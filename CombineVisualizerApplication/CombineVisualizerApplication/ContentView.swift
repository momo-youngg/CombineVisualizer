//
//  ContentView.swift
//  CombineVisualizerApplication
//
//  Created by momo on 2023/05/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CombineView()
            .padding()
            .onAppear {
                CombineVisualizerServer.shared.start()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
