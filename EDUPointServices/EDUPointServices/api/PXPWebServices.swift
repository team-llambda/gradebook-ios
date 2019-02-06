//
//  PXPWebServices.swift
//  EDUPointServices
//
//  Created by Alan Chu on 1/30/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import Alamofire
import Promises
import XMLParsing

public class PXPWebServices {
    public let userID: String
    public let password: String
    public let edupointBaseURL: URL
    
    fileprivate lazy var xmlDecoder: XMLDecoder = {
        let decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        decoder.dataDecodingStrategy = .deferredToData
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }()
    
    public init(userID: String, password: String, edupointBaseURL: URL) {
        self.userID = userID
        self.password = password
        self.edupointBaseURL = edupointBaseURL
    }
    
    public func processWebRequest<E: Decodable>(methodToRun: PXPWebServicesFunction, type: E.Type) -> Promise<E> {
        return Promise<E>(on: .main) { (fulfill, reject) in
            let requestURL = URL(string: self.edupointBaseURL.absoluteString + "Service/PXPCommunication.asmx/ProcessWebServiceRequest")!
            let requestParameters: [String: String] = [
                "userID": self.userID,
                "password": self.password,
                "skipLoginLog": "false",
                "parent": "false",
                "webServiceHandleName": "PXPWebServices",
                "methodName": methodToRun.methodName,
                "paramStr": methodToRun.parameters
            ]
            
            AF.request(requestURL, method: .post, parameters: requestParameters)
                .responseString(completionHandler: { (response) in
                    if let error = response.error {
                        reject(error)
                        return
                    }
                    
                    guard let formattedData = response.value?
                        .replacingOccurrences(of: "&amp;", with: "&")
                        .replacingOccurrences(of: "&lt;", with: "<")
                        .replacingOccurrences(of: "&gt;", with: ">")
                        .data(using: .utf8) else {
                            reject(APIError.unexpectedResponse)
                            return
                    }

                    do {
                        fulfill(try self.xmlDecoder.decode(type, from: formattedData))
                    } catch(let error) {
                        reject(error)
                    }
                })
        }
    }
}
