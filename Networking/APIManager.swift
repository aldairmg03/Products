//
//  APIManager.swift
//  Products
//
//  Created by Aldair Martínez on 24/11/22.
//

import Foundation
import Combine

class APIManager {
    
    public static let shared = APIManager()
        
    private var suscriber = Set<AnyCancellable>()
    
    func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("adb8204d-d574-4394-8c1a-53226a40876e", forHTTPHeaderField: "X-IBM-Client-Id")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { (resultCompletion) in
                switch resultCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    return
                }
            } receiveValue: { (result) in
                completion(.success(result))
            }
            .store(in: &suscriber)
    }
    
}
