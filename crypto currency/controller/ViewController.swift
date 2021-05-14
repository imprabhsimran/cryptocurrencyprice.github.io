//
//  ViewController.swift
//  crypto currency
//
//  Created by Prabh Simran Singh on 20/12/20.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate,bitDeligate{
    
    
    var coinManager = CoinManager()
    var selectedCurrency : String = ""
    var selectedCoin : String = ""
    var lol = "100"
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinPicker: UIPickerView!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinPicker.dataSource = self
        coinPicker.delegate = self
        coinManager.deligate = self
    }
// MARK:-
    
    func didUpdateValue(price: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = price
        }
        
    }
    
    func didFailError(error: Error) {
        return
    }
    
    
// MARK:-
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == coinPicker{
            return coinManager.coinArray.count
        }else{
            return coinManager.currencyArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == coinPicker{
         selectedCoin = coinManager.coinArray[row]
        }else {
         selectedCurrency = coinManager.currencyArray[row]
            currencyLabel.text = selectedCurrency
        }
         coinManager.getCoinPrice(coin: selectedCoin, currency: selectedCurrency)
        }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == coinPicker{
            return coinManager.coinArray[row]
        }else{
            return coinManager.currencyArray[row]
        }
        }
    
}

