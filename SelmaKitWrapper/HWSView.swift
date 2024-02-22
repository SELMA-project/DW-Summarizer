//
//  HWSView.swift
//  SelmaKitWrapper
//
//  Created by Andy Giefer on 26.07.23.
//

import SwiftUI

struct HWSView: View {
    @State private var lines = [String]()
    @State private var status = "Fetching…"

    var body: some View {
        VStack {
            Text("Count: \(lines.count)")
            Text("Status: \(status)")
        }
        .task {
                do {
                    let url = URL(string: "https://hws.one/slow-fetch")!

                    for try await line in url.lines {
                        lines.append(line)
                    }

                    status = "Done!"
                } catch {
                    status = "Error thrown."
                }
            }
    }
}
