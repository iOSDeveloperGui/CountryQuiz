//
//  MockURLProtocol.swift
//  CountryQuizTests
//
//  Created by iOS Developer on 06/09/25.
//

class MockURLProtocol: URLProtocol{
    static var testResponse: (Data?, HTTPURLResponse?, Error?)?
    
    override class func canInit(withRequest: URLRequest) -> Bool{
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest{
        return request
    }
    
    override func startLoading(){
        if let(data, response, error) = MockURLProtocol.testResponse{
            if let error = error{
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let response = response{
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data{
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading(){}
}
