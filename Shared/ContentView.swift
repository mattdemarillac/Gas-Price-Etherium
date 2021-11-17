//
//  ContentView.swift
//  Shared
//
//  Created by matt on 15/11/21.
//

import SwiftUI
import UIKit

struct JSONData: Codable {
    let code: Int
    var data: GasData
}

struct GasData: Codable {
    let rapid: Int
    let standard: Int
    let slow: Int
    let timestamp: Int
    let priceUSD: Float
}

struct ContentView: View {
    @State private var text = "Loading..."
    
    var body: some View {
        Text(self.text)
            .task {
                do {
                    let url = URL(string: "https://etherchain.org/api/gasnow")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let jsonData = try JSONDecoder().decode(JSONData.self, from: data)
                    
                    let fast = String(jsonData.data.rapid).index(String.Index, offsetBy: String.IndexDistance, limitedBy: <#T##String.Index#>)
                    
                    let standard = String(jsonData.data.standard).index(String.Index, offsetBy: String.IndexDistance, limitedBy: <#T##String.Index#>)
                    
                    let slow = String(jsonData.data.slow).index(String.Index, offsetBy: String.IndexDistance, limitedBy: <#T##String.Index#>)
                    
                    let etherPrice = jsonData.data.priceUSD
                    
                    text =
                        "Fast: " + fast + " GWei" +
                        "\nStandard: " + standard + " GWei" +
                        "\nSlow: " + slow + " GWei"
                } catch {
                    print(error)
                    text = "Error"
                }
                
            }
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
