//
//  SummarisationView.swift
//  SelmaKitWrapper
//
//  Created by Andy Giefer on 15.06.23.
//

import SwiftUI
import SelmaKit
import DWUtilities

struct SummarisationView: View {
    
    @AppStorage("promptText") var promptText: String = "Summarize as radio report in the style of Deutsche Welle in fewer than 40 words."
    @AppStorage("incomingText") var incomingText: String = "After four days of negotiations in Beijing, an agreement has been reached between Saudi Arabia and Iran to restore diplomatic ties. While  reactions from pundits and politicians have ranged from euphoria to cynicism to outright hostility, reality dictates that cautious optimism is the better course. Here are a few observations on what just happened and why, and what needs to happen next."
    @AppStorage("openAPIKey") var openAIKey = ""
    
    @State var outgoingText: String = ""
    @State var engineIsProcessing = false
    @AppStorage("temperature") var temperature: Double = 0.5
    @AppStorage("maxNumberOfTokens") var maxNumberOfTokens: Int = 400
    @AppStorage("selectedEngine") var selectedEngine: Engine = .openAI
    
    var temperatureIsControllable: Bool {
        return (selectedEngine == .openAI) || (selectedEngine == .priberam)
    }
    
    let tokenNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    enum Engine: String, CaseIterable, Identifiable {
        case openAI, alpaca, llama, priberam
        
        var id: String {
            return displayName
        }
        
        var displayName: String {
            switch self {
            case .alpaca:
                return "Alpaca"
            case .openAI:
                return "OpenAI"
            case .llama:
                return "LLaMA"
            case .priberam:
                return "Priberam"
            }
            
        }
    }
    

    
    func process() {
        
        switch selectedEngine {
        case .openAI:
            summarizeWithOpenAI()
        case .alpaca:
            summarizeWithAlpaca()
        case .llama:
            completeWithLlama()
        case .priberam:
            summarizeWithPriberam()
        }
        
    }
    
    func summarizeWithAlpaca() {
        let selmaAPI = SelmaAPI()
        Task {
            
            engineIsProcessing = true
            
            let stream = await selmaAPI.sendAlpacaRequest(predictionLength: maxNumberOfTokens, prompt: promptText, context: incomingText)
            
            if let stream {
                for try await character in stream.characters {
                    //print("\(Date())\tReceived character: \(character)")
                    outgoingText.append(character)
                }
            } else {
                outgoingText = "<SELMA Server error.>"
            }
            
            engineIsProcessing = false
        }
    }
        
    func completeWithLlama() {
        //let text = "The moon is very cold and"
        
        let selmaAPI = SelmaAPI()
        Task {
            let stream = await selmaAPI.sendLlamaRequest(predictionLength: maxNumberOfTokens, input: incomingText)
            
            if let stream {
                for try await character in stream.characters {
                    outgoingText.append(character)
                }
            } else {
                outgoingText = "<SELMA Server error.>"
            }
            
        }
    }
    
    func summarizeWithOpenAI()   {
        
        Task {
            let key = UserDefaults.standard.string(forKey: Constants.userDefaultsOpenAIAPIKeyName)
            let openAI = CleverBirdManager(key: key)
            
            // signal to ProgressView
            engineIsProcessing = true
            
            // send request to OpenAI
            let receivedText = await openAI.summarize(prompt: promptText, context: incomingText, temperature: temperature, maxTokens: maxNumberOfTokens)
            
            // separate sentences by newlines
            outgoingText = receivedText.split(separator: ". ").joined(separator: ".\n\n")
            
            // signal to ProgressView
            engineIsProcessing = false
        }
        
    }

    func summarizeWithPriberam() {
        
        Task {
            
            // signal to ProgressView
            engineIsProcessing = true
            
            // summarize
            let summerizer = PriberamSummerizer()
            if let summary = await summerizer.summarizeUsingExtractiveEBR(text: incomingText, minimumCharacterLength: maxNumberOfTokens-100, maximumCharacterLength: maxNumberOfTokens, diversityWeight: temperature) {
                outgoingText = summary
            } else {
                print("Did not receive a valid result from PriberamSummerizer.")
            }
            
            // signal to ProgressView
            engineIsProcessing = false
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Prompt")
                    .font(.title2)
                    .bold()
                    .padding([.leading, .top, .trailing], 40)
                
                
                TextEditor(text: $promptText)
                    .font(.title3)
                    .frame(height: 30)
                    .padding([.leading, .trailing, .bottom], 35)
                    .disabled(selectedEngine == .llama)
                    .foregroundColor(selectedEngine != .llama ? .primary : .secondary)
                
                
                // Two textviews
                
                HStack {
                    // Original text
                    VStack(alignment: .leading) {
                        
                        // Header
                        HStack(alignment: .center) {
                            TextBlockHeadView(title: "Original Text", text: incomingText)
                                
                            Spacer()
                            
                            Label("DW Article", systemImage: "plus.circle")
                                .foregroundColor(.white)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 8).fill(.blue))
                                .dropDestination(for: Data.self) { dataArray, _ in
                                    
                                    var success = false
                                    
                                    let dwManager = DWManager()
                                    
                                    Task {
                                        if let dwArticle = await dwManager.extractDWArticle(fromDataArray: dataArray) {
                                            incomingText = "\(dwArticle.title).\n\n\(dwArticle.formattedText)"
                                            success = true
                                        }
                                    }
                                    
                                    return success
                                }
                        }.padding([.leading], 40)
 
                        // Text
                        TextEditor(text: $incomingText)
                            .font(.title3)
                            .padding([.leading, .trailing], 40)

                    }
                    
                    Divider()
                    
                    // Processed text
                    VStack(alignment: .leading) {
                        TextBlockHeadView(title: "Processed Text", text: outgoingText)
                            .padding([.leading, .trailing], 40)
                        
                        ZStack {
                            if outgoingText.count > 0 {
                                TextEditor(text: $outgoingText)
                                    .font(.title3)
                                    .padding([.leading, .trailing], 40)
                                    
                            } else {
                                HStack {
                                    Text("The processed text will appear here.")
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                        .padding(.leading, 40)
                                    Spacer()
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
            }.background(ignoresSafeAreaEdges: .all)

            // Bottom section with controls
            
            HStack {
                
                // Engine
                Picker("Engine:", selection: $selectedEngine) {
                    ForEach(Engine.allCases) { engine in
                        Text(engine.displayName).tag(engine)
                    }
                }
                .frame(width: 150)
                .padding(.leading, 40)
                
                // Token number
                Text("Tokens:")
                    .padding(.leading)

                TextField("Max. number of Tokens:", value: $maxNumberOfTokens, formatter: tokenNumberFormatter)
                    .frame(width: 100)
                
                // Temperature
                Stepper(value: $temperature, in: 0...1, step: 0.1) {
                    Text("Temperature: \(temperature.formatted(.number.precision(.fractionLength(1))))")
                        .foregroundColor(temperatureIsControllable ? .primary : .secondary)
                }
                .padding(.leading)
                .disabled(!temperatureIsControllable)
                
                Spacer()
                
                // Progress View
                ProgressView()
                    .scaleEffect(0.5, anchor: .center)
                    .opacity(engineIsProcessing ? 1 : 0)
                    
                // Button
                Button("Process") {
                    outgoingText = ""
                    print("Processing")
                    process()
                }
                .disabled(engineIsProcessing)
            } .padding(8)
            
        }
        
    }
}

struct SummarisationView_Previews: PreviewProvider {
    static var previews: some View {
        SummarisationView()
            .frame(width: 800, height: 600)
    }
}


