//
//  ApplStock.swift
//  AC-iOS-U3W1HW-Parsing
//
//  Created by Luis Calle on 11/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class ApplStock {

    let date: String
    let open: Double
    let close: Double
    
    init(date: String, open: Double, close: Double) {
        self.date = date
        self.open = open
        self.close = close
    }
    convenience init?(from dict: [String: Any]) {
        guard let date = dict["date"] as? String else { return nil }
        guard let open = dict["open"] as? Double else { return nil }
        guard let close = dict["close"] as? Double else { return nil }
        self.init(date: date, open: open, close: close)
    }
    
    static func getApplStocks(from data: Data) -> [ApplStock] {
        var stocks = [ApplStock]()
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let stocksDictArray = json as? [[String: Any]] else { return [] }
            for stockDict in stocksDictArray {
                if let newStock = ApplStock(from: stockDict) {
                    stocks.append(newStock)
                }
            }
        }
        catch {
            print("Error")
        }
        return stocks
    }
    
    static func makeStockTupleByMonth(stocks: [ApplStock]) -> [(key: String, value: [ApplStock])] {
        var stocksByMonthDict = [String: [ApplStock]]()
        let allStocks = stocks
        for stock in allStocks {
            let date = stock.date
            var arrDate = date.components(separatedBy: "-")
            arrDate.removeLast()
            let dateKey = arrDate.joined(separator: "-")
            if let stocksSoFar = stocksByMonthDict[dateKey] {
                var toAddNewStock: [ApplStock] = stocksSoFar
                toAddNewStock.append(stock)
                stocksByMonthDict.updateValue(toAddNewStock, forKey: dateKey)
            } else {
                stocksByMonthDict[dateKey] = [stock]
            }
        }
        return stocksByMonthDict.sorted{ $0.key < $1.key }
    }
    
    static func dateConversion(dateStr: String) -> (month: String, Year: String)? {
        let arrDate = dateStr.components(separatedBy: "-")
        var month: String
        guard let year = arrDate.first, let monthNumber = arrDate.last else { return nil }
        guard let monthNumberInt = Int(monthNumber) else { return nil }
        switch monthNumberInt {
        case 1:
            month = "January"
        case 2:
            month = "February"
        case 3:
            month = "March"
        case 4:
            month = "April"
        case 5:
            month = "May"
        case 6:
            month = "June"
        case 7:
            month = "July"
        case 8:
            month = "August"
        case 9:
            month = "September"
        case 10:
            month = "October"
        case 11:
            month = "November"
        case 12:
            month = "December"
        default:
            month = "Unknown month"
        }
        return (month, year)
    }
    
    static func findMonthAverage(stockArr: [ApplStock]) -> Double {
        return (stockArr.reduce(0.0){$0 + $1.open}) / Double(stockArr.count)
    }
    
}
