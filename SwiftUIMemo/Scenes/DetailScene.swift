//
//  DetailScene.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/19.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import SwiftUI

struct DetailScene: View {
    @ObservedObject var memo: MemoEntity
    
    @EnvironmentObject var store: CoreDataManager
    @EnvironmentObject var formatter: DateFormatter
    
    @State private var isPresentedEditScene = false
    @State private var isPresentedDeleteAlert = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text(self.memo.content ?? "")
                            .padding()
                        
                        Spacer()
                    }
                    
                    Text("\(self.memo.insertDate ?? Date(), formatter: formatter)")
                        .padding()
                        .font(.footnote)
                        .foregroundColor(Color(.secondaryLabel))
                }
            }
            
            HStack {
                DeleteButton(isPresented: $isPresentedDeleteAlert,
                             memo: self.memo)
                
                Spacer()
                
                EditButton(isPresented: $isPresentedEditScene,
                           memo: self.memo)
            }
            .padding(.leading)
            .padding(.trailing)
        }
        .navigationBarTitle("메모 보기")
    }
}

fileprivate struct DeleteButton: View {
    @Binding var isPresented: Bool
    var memo: MemoEntity
    @EnvironmentObject var store: CoreDataManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(systemName: "trash")
                .foregroundColor(Color(.systemRed))
        })
            .padding()
            .alert(
                isPresented: $isPresented,
                content: {
                    Alert(
                        title: Text("삭제 확인"),
                        message: Text("정말로 메모를 삭제하시겠습니까?"),
                        primaryButton: .destructive(
                            Text("삭제"),
                            action: {
                                self.store.delete(memo: self.memo)
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        ),
                        secondaryButton: .cancel()
                    )
            }
        )
    }
}

fileprivate struct EditButton: View {
    @Binding var isPresented: Bool
    var memo: MemoEntity
    @EnvironmentObject var store: CoreDataManager
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(systemName: "square.and.pencil")
        })
            .padding()
            .sheet(
                isPresented: $isPresented,
                content: {
                    ComposeScene(showComposer: self.$isPresented, memo: self.memo)
                        .environmentObject(self.store)
                        .environmentObject(KeyboardObserver())
            }
        )
    }
}

struct DetailScene_Previews: PreviewProvider {
    static var previews: some View {
        DetailScene(memo: MemoEntity(context: CoreDataManager.mainContext))
            .environmentObject(CoreDataManager.shared)
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}
