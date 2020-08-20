//
//  HelperFunctions.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-08-20.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    //currencyFormatter.locale = Locale.current
    currencyFormatter.currencySymbol = .init(stringLiteral: "€ ")
    
    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    return priceString
}
