//
//  TextView2.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/08/02.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import SwiftUI

struct TextView2: UIViewRepresentable {
  @Binding var text: String
  @Binding var font: UIFont

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.font = font
    textView.delegate = context.coordinator
    
    return textView
  }
  
  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.font = font
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator($text)
  }
  
  class Coordinator: NSObject {
    var text: Binding<String>
    
    init(_ text: Binding<String>) {
      self.text = text
    }
  }
}

extension TextView2.Coordinator: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.text.wrappedValue = textView.text
  }
}
