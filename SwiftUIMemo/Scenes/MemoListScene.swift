//
//  ContentView.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/12.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import SwiftUI

struct MemoListScene: View {
    @EnvironmentObject var store: CoreDataManager
    @EnvironmentObject var formatter: DateFormatter
    
    @State var showComposer: Bool = false
    
    @FetchRequest(
        entity: MemoEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(
                keyPath: \MemoEntity.insertDate,
                ascending: false)
        ]
    )
    
    var memoList: FetchedResults<MemoEntity>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(memoList) { memo in
                    NavigationLink(
                        destination: DetailScene(memo: memo),
                        label: {
                            MemoCell(memo: memo)
                    }
                    )
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("내 메모")
            .navigationBarItems(trailing: ModalButton(show: $showComposer))
            .sheet(isPresented: $showComposer, content: {
                ComposeScene(showComposer: self.$showComposer)
                    .environmentObject(self.store)
                    .environmentObject(KeyboardObserver())
            })
        }
    }
    
    func delete(set: IndexSet) {
        DispatchQueue.main.async {
            for index in set {
                self.store.delete(memo: self.memoList[index])
            }
        }
    }
}

fileprivate struct ModalButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {
            self.show = true
        }, label: {
            Image(systemName: "plus")
        })
    }
}

struct MemoListScene_Previews: PreviewProvider {
    static var previews: some View {
        MemoListScene()
            .environmentObject(CoreDataManager.shared)
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}
