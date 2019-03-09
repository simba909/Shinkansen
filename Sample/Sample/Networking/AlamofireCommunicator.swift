//
//  AlamofireCommunicator.swift
//  Sample
//
//  Created by Simon Jarbrant on 2019-03-08.
//  Copyright © 2019 Simon Jarbrant. All rights reserved.
//

import Alamofire
import DangoKit

enum AlamofireCommunicatorError: Error {
    case unknownFailure
}

class AlamofireCommunicator: Communicator {
    func performRequest<E>(to endpoint: E, completionHandler: @escaping (DangoKit.Result<E.Parser.DataType>) -> Void) where E : Endpoint {
        let targetURL = endpoint.baseURL.appendingPathComponent(endpoint.path)
        let params = endpoint.queryItems.alamofireParameterized()
        let method = endpoint.method.alamofireMethod

        Alamofire.request(targetURL, method: method, parameters: params, encoding: URLEncoding(destination: .queryString))
            .response { response in
                switch (response.response, response.data, response.error) {
                case (let response?, let data?, _):
                    do {
                        let parsedData = try endpoint.responseParser.parse(response: response, data: data)
                        completionHandler(.success(parsedData))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case (_, _, let error?):
                    completionHandler(.failure(error))
                case (_, _, _):
                    completionHandler(.failure(AlamofireCommunicatorError.unknownFailure))
                }
        }
    }
}

private extension DangoKit.HTTPMethod {
    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get:
            return Alamofire.HTTPMethod.get
        case .put:
            return Alamofire.HTTPMethod.put
        case .post:
            return Alamofire.HTTPMethod.post
        case .delete:
            return Alamofire.HTTPMethod.delete
        }
    }
}

private extension Collection where Element == URLQueryItem {
    func alamofireParameterized() -> Parameters {
        var params: Parameters = [:]
        params.reserveCapacity(self.count)

        for queryItem in self {
            params[queryItem.name] = queryItem.value
        }

        return params
    }
}
