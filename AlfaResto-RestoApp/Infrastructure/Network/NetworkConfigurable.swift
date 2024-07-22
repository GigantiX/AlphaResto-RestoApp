//
//  NetworkConfigurable.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import Alamofire

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: HTTPHeaders { get }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    var baseURL: URL
    var headers: HTTPHeaders
    var queryParameters: [String : String]
    
    init(baseURL: URL,
         headers: HTTPHeaders = [.contentType("application/json")],
         queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
