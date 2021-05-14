//
//  CoinManager.swift
//  crypto currency
//
//  Created by Prabh Simran Singh on 21/12/20.
//

import Foundation
protocol bitDeligate {
    func didUpdateValue(price: String)
    func didFailError(error: Error)
}
struct CoinManager {
    var deligate : bitDeligate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let coinArray = ["BTC","BCH","LTC","ETH","XRP","XLM","NEO","ADA","IOTA"]
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "?apikey=51E9B9B4-F522-43EE-8FEE-D54C023DB9A3"
    func getCoinPrice(coin : String, currency : String){
      let urlString = "\(baseURL)\(coin)/\(currency)\(apiKey)"
        performRequest(urlString: urlString)
    }
    func performRequest(urlString : String){
        if let url = URL(string: urlString){
            
           let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    return
                }
                if let safeData = data{
                    let final = parseJSON(currencyData: safeData)
                    let lastPrice = String(format: "%.2f", final!)
                    deligate?.didUpdateValue(price: lastPrice)
                }
            }
            
            task.resume()
        }
        
    }
    func parseJSON(currencyData : Data) -> Double?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(Ddata.self, from: currencyData)
            print(decodedData.rate)
            return decodedData.rate
        } catch{
            return 0.0
        }
    }
}
