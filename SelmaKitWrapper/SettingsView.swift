//
//  SettingsView.swift
//  DW Summarizer
//
//  Created by Andy Giefer on 31.07.23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(Constants.userDefaultsOpenAIAPIKeyName) var openAIAPIKey = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Settings").font(.title)
            
            Form {
                TextField("OpenAI API Key:", text: $openAIAPIKey)
            }
            
        
        }
        .padding()
        .frame(width: 500)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
