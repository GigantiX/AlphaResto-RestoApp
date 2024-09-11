//
//  Endpoint.swift
//  AlfaResto-RestoApp
//
//  Created by Geraldy Kumara on 26/06/24.
//

import Foundation
import Alamofire

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var headerParameters: HTTPHeaders { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    
    func url(with config: NetworkConfigurable) throws -> URL
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

class Endpoint<R>: ResponseRequestable {
    typealias Response = R
        
    var path: String
    var isFullPath: Bool
    var method: HTTPMethod
    var headerParameters: Alamofire.HTTPHeaders
    var queryParametersEncodable: Encodable?
    var queryParameters: [String : Any]
    var bodyParameters: [String : Any]
    var bodyParametersEncodable: Encodable?
    
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod,
         headerParameters: Alamofire.HTTPHeaders = [],
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String : Any] = [:],
         bodyParameters: [String : Any] = [:],
         bodyParametersEncodable: Encodable? = nil
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.bodyParametersEncodable = bodyParametersEncodable
    }
    
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { return URL(fileURLWithPath: "") }
        
        var urlQueryItems = [URLQueryItem]()
        
        if !self.queryParameters.isEmpty {
            queryParameters.forEach {
                urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
            config.queryParameters.forEach {
                urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            }
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { return URL(fileURLWithPath: "") }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: HTTPHeaders = config.headers
        
        headerParameters.forEach {
            allHeaders.update($0)
        }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters)
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = allHeaders
        
        return urlRequest
    }
}

private extension Requestable {
    func encodeBody(bodyParameters: [String: Any]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: bodyParameters)
            return data
        } catch {
            debugPrint(error)
            return nil
        }
    }
}


