//
//  cryptowidgrt.swift
//  cryptowidgrt
//
//  Created by Prabh Simran Singh on 29/12/20.
//

import WidgetKit
import SwiftUI
import Intents

let loader: ViewController = ViewController()

protocol bitdDeligate {
    func didUpdateValue(price: String)
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let bitValue : String
}


var widgetPrice : String = ""


struct CcoinManager {
    var deligate : bitdDeligate?
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


func didUpdateValue(price: String) {
        widgetPrice = price
    
}



struct Provider: TimelineProvider {
   
    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
       
       let currentDate = Date()
        let entry : [SimpleEntry] = [SimpleEntry(date: currentDate, bitValue: widgetPrice)]
       let refreshDate = Calendar.current.date(byAdding: .minute, value : 60 ,to: currentDate)!
       let timeline = Timeline(entries: entry, policy: .after(refreshDate))
       completion(timeline)
       print(widgetPrice)
       
}

   
   
  public func placeholder(in context: Context) -> SimpleEntry {
       SimpleEntry(date: Date(), bitValue: widgetPrice)
   }

   public func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
       let entry = SimpleEntry(date: Date(), bitValue: widgetPrice)
       completion(entry)
   }
}

    


struct PlaceholderView : View {
     var body: some View {
        
            Text("Placeholder View")
        }
}

struct cryptowidgrtEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        HStack{
        Text(entry.date, style: .date)
                Text(entry.bitValue)
             .previewContext(WidgetPreviewContext(family: .systemMedium))
        }    .background(Color.yellow)
    }

}

@main
struct cryptowidgrt: Widget {
    let kind: String = "cryptowidgrt"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            cryptowidgrtEntryView(entry: entry)
        }
        .configurationDisplayName("Crypto Currancy")
        .description("Shows the price of bit coins")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
    struct cryptowidgrt_Previews: PreviewProvider {
    static var previews: some View {
        cryptowidgrtEntryView(entry: SimpleEntry(date: Date(), bitValue: "hello" ))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
