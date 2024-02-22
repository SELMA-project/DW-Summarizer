////
////  OpenAI+OpenAISwift.swift
////  SelmaKitWrapper
////
////  Created by Andy Giefer on 27.07.23.
////
//
//import Foundation
//import OpenAISwift
//
//class OpenAITester {
//    
//    var openAI: OpenAISwift
//    
//    init(key: String) {
//        openAI = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: key))
//    }
//    
//    func process() async {
//        
//        print("Processing...")
//        
//        do {
//            let result = try await openAI.sendCompletion(
//                with: "What's your favorite color?",
//                model: .gpt3(.davinci), // optional `OpenAIModelType`
//                maxTokens: 16,          // optional `Int?`
//                temperature: 0.5          // optional `Double?`
//            )
//            // use result
//
//            print("Ready")
//
//            print(result.choices?.first?.text ?? "")
//
//
//
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func summarize() async {
//        
//        let prompt = "Summarize the text as radio report in the style of Deutsche Welle. The output should have fewer than 40 words."
//        
//        let context = "After four days of negotiations in Beijing, an agreement has been reached between Saudi Arabia and Iran to restore diplomatic ties. While  reactions from pundits and politicians have ranged from euphoria to cynicism to outright hostility, reality dictates that cautious optimism is the better course. Here are a few observations on what just happened and why, and what needs to happen next."
//        
//        let resultText = await summarizeWithCompletion(prompt: prompt, context: context)
//        print(resultText)
//    }
//    
//    func summarizeWithEditEndpoint(prompt: String, context: String) async -> String {
//        var resultText = "An error occurred while summarizing."
//  
//        do {
//            let result = try await openAI.sendEdits(
//                with: prompt,
//                model: .feature(.davinci),               // optional `OpenAIModelType`
//                input: context
//            )
//            // use result
//            resultText = result.choices?.first?.text ?? ""
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        return resultText
//        
//    }
//    
//    func summarizeWithCompletion(prompt: String, context: String) async -> String {
//        
//        var resultText = "An error occurred while summarizing."
//        
//        let userText = "\(prompt)\n\n\(context)"
//        
//        do {
//            let result = try await openAI.sendCompletion(
//                with: userText,
//                model: .gpt3(.davinci), // optional `OpenAIModelType`
//                temperature: 1.0          // optional `Double?`
//            )
//            // use result
//            resultText = result.choices?.first?.text ?? "<no summary provided>"
//            
//        } catch {
//            print(error.localizedDescription)
//            print(error)
//        }
//        
//        return resultText.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//    
//    func summarizeWithChatCompletion(prompt: String, context: String) async -> String {
//        
//        var resultText = "An error occurred while summarizing."
//  
//        do {
//            let chat: [ChatMessage] = [
////                ChatMessage(role: .system, content: prompt),
////                ChatMessage(role: .user, content: context)
//                ChatMessage(role: .system, content: "You are a helpful assistant."),
//                ChatMessage(role: .user, content: "Who won the world series in 2020?"),
//                ChatMessage(role: .assistant, content: "The Los Angeles Dodgers won the World Series in 2020."),
//                ChatMessage(role: .user, content: "Where was it played?")
//            ]
//
//            let result = try await openAI.sendChat(with: chat, model: .chat(.chatgpt), temperature: 0.2)
//
//            if let message = result.choices?.first?.message {
//                resultText = message.content ?? "<no summary provided>"
//            }
//
//            // use result
//        } catch {
//            print(error.localizedDescription)
//            print(error)
//        }
//        
//        return resultText
//    }
//    
//    func streamTest() async {
//
//        for await result in openAI.sendStreamingChat(with: [
//            ChatMessage(role: .user, content: "write 1000 words story")
//        ]) {
//            switch result {
//            case .success(let success):
//                print(success.choices?.first?.delta.content ?? "")
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
// 
//    }
//
//}
//
