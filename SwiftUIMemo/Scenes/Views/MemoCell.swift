//
//  MemoCell.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/12.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import SwiftUI

struct MemoCell: View {
    @ObservedObject var memo: MemoEntity
    @EnvironmentObject var formatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(memo.content ?? "")
                .font(.body)
                .lineLimit(1)
            
            Text("\(memo.insertDate ?? Date(), formatter: self.formatter)")
                .font(.caption)
                .foregroundColor(Color(UIColor.secondaryLabel))
        }
    }
}

struct MemoCell_Previews: PreviewProvider {
    static var previews: some View {
        MemoCell(memo: MemoEntity(context: CoreDataManager.mainContext))
            .environmentObject(DateFormatter.memoDateFormatter)
    }
}
