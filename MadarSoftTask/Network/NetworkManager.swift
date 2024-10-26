//
//  NetworkManager.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import Foundation
import Network

protocol NetworkServiceProtocol {
    func isConnectedToNetwork() -> Bool
    func fetchData<T: Codable>(from urlString: String) async throws -> T
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Failed to decode the response."
        case .noInternetConnection:
            return "No internet connection available."
        }
    }
}

class NetworkManager: NetworkServiceProtocol {
    func isConnectedToNetwork() -> Bool {
        let monitor = NWPathMonitor()
        var isConnected = false
        let semaphore = DispatchSemaphore(value: 0)
        
        monitor.pathUpdateHandler = { path in
            isConnected = path.status == .satisfied
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        semaphore.wait()
        monitor.cancel()
        
        return isConnected
    }
    
    func fetchData<T: Codable>(from urlString: String) async throws -> T {
        guard isConnectedToNetwork() else {
            throw NetworkError.noInternetConnection
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
       
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError
        }
    }
}
