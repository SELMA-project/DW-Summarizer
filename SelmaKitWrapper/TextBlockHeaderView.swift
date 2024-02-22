//
//  TextBlockHeaderView.swift
//  SelmaKitWrapper
//
//  Created by Andy Giefer on 27.07.23.
//

import SwiftUI

struct TextBlockHeadView: View {
    
    var title: String
    var text: String

    var numberOfWords: Int {
        
        let strComponents = text.components(separatedBy: .whitespacesAndNewlines)
        let wordsArray = strComponents.filter { !$0.isEmpty }
        
        return wordsArray.count
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title2)
                .bold()
            
            Text("\(numberOfWords) words")
                .foregroundColor(.gray)
                    
  
        }
    }
}
