//
//  ObservableListScene.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/26.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import SwiftUI

class ObservableList: ObservableObject {
    @Published var list: [String] = []
}

struct ContentView: View {
    @State var text: String = ""
    @ObservedObject var list = ObservableList()
    
    var body: some View {
        VStack {
            Text(text)
            
            HStack {
                TextField("type text", text: $text)
                
                CreateButton(text: $text, list: self.list)
            }
            
            List(list.list, id: \.self) { item in
                Text(item)
            }
        }
        .padding()
    }
}

struct CreateButton: View {
    @Binding var text: String
    var list: ObservableList
    
    var body: some View {
        Button(action: {
            self.list.list.insert(self.text, at: 0)
            self.text = ""
        }, label: {
            Text("Create List")
        })
    }
}

struct ObservableListScene_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
