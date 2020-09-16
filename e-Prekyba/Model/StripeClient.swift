//
//  StripeClient.swift
//  e-Prekyba
//
//  Created by Arvydas Klimavicius on 2020-09-16.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    static let sharedClient = StripeClient()
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = self.baseURLString, let url = URL(string: urlString) {
            return url
        } else {
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping (_ error: Error?) -> ()) {
        
    }
}
