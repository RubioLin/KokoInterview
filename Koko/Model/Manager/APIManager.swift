import Foundation
import Combine

class APIManager {
    
    // MARK: - Method
    func createRequest(url: String, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = "GET"
        
        return request
    }
    
    func operateRequest<T: Decodable>(request: URLRequest?, type: T.Type) async -> T? {
        guard let request = request else { return nil }
        guard let (data, response) = try? await URLSession.shared.data(for: request) else { return nil }
        
        do {
            switch (response as! HTTPURLResponse).statusCode {
            case 200:
                debugPrint("OK")
            case 304:
                debugPrint("Not modified")
            case 422:
                debugPrint("Validation failed, or the endpoint has been spammed.")
            case 503:
                debugPrint("Service unavailable")
            default:
                break
            }
            let decodedData = try JSONDecoder().decode(type, from: data)
            return decodedData
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func test<T: Codable>(request: URLRequest, type: T.Type) {
        
    }
    
    func operateRequestReturnDataTaskPublisher<T: Codable>(request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                switch response.statusCode {
                case 200:
                    debugPrint("OK")
                case 304:
                    debugPrint("Not modified")
                case 422:
                    debugPrint("Validation failed, or the endpoint has been spammed.")
                case 503:
                    debugPrint("Service unavailable")
                default:
                    break
                }
                
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: type.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                debugPrint(error.localizedDescription)
                return error
            }
            .eraseToAnyPublisher()
        
    }
    
    func operateRequest(request: URLRequest?) async -> Data? {
        guard let request = request else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(for: request) else { return nil }
        return data
    }
}
