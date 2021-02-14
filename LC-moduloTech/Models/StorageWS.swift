//
//  StorageWS.swift
//  LC-moduloTech
//
//  Created by owee on 14/02/2021.
//

import Foundation

private protocol StorageWSAPI {
    func fetchDeviceList(Callback:@escaping (Result<StorageWS.StorageReponse,Error>) -> Void)
}

final class StorageWS {
    
    private let session : URLSession
    
    public init(Session:URLSession=URLSession.shared) {
        self.session = Session
    }
    
    enum APIError : Error {
        case invalidRequest
    }
    
    enum Endpoint {
        
        case Data
        
        var request : URLRequest? {
            
            switch self {
            case .Data:
                
                let path = "http://storage42.com/modulotest/data.json"
                guard let url = URLComponents(string: path)?.url else { return nil }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
                
            }
            
        }
    }
    
    private func task<Reponse:Codable>(Request:URLRequest, Completion:@escaping (Result<Reponse,Error>) -> Void) {
        
        self.session.dataTask(with: Request) { (Data, Rep, Err) in
            
            if let error = Err {
                return Completion(.failure(error))
            }
            
            else if let data = Data {
                
                do {
                    
                    let reponse = try JSONDecoder().decode(Reponse.self, from: data)
                    Completion(.success(reponse))
                    
                } catch let error  {
                    Completion(.failure(error))
                }
            }
            
        }.resume()
    }
}

extension StorageWS : StorageWSAPI {
    
    struct StorageReponse: Codable {
        let devices: [Device]
        let user: User
    }

    struct Device: Codable {
        let id: Int
        let deviceName: String
        let intensity: Int?
        let mode: String?
        let productType: ProductType
        let position, temperature: Int?
        
        enum ProductType: String, Codable {
            case heater = "Heater"
            case light = "Light"
            case rollerShutter = "RollerShutter"
        }
    }

    struct User: Codable {
        let firstName, lastName: String
        let address: Address
        let birthDate: Int
        
        struct Address: Codable {
            let city: String
            let postalCode: Int
            let street, streetCode, country: String
        }
    }
    
    func fetchDeviceList(Callback: @escaping (Result<StorageWS.StorageReponse, Error>) -> Void) {
        
        guard let request = Endpoint.Data.request else {
            return Callback(.failure(APIError.invalidRequest))
        }
        
        self.task(Request: request, Completion: Callback)
    }
    
}
