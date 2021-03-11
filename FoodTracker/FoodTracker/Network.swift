import UIKit
import SwiftyJSON

enum ServerAPI: NSInteger {
    case EdamamFoodAndGroceryDatabase        //SV Anh Nam
    case VivaCityDocumentationAPIDocumentation //https://rapidapi.com/din-dins-club-limited-din-dins-club-limited-default/api/viva-city-documentation
}

enum Result<Success, Error: Swift.Error> {
    case success(Success)
    case failure(Error)
}

// override the Result.get() method
extension Result {
    func get() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}

// use generics - this is where you can decode your data
extension Result where Success == Data {
    func decoded<T: Decodable>(using decoder: JSONDecoder = .init()) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}

class Network {
    static let shared: Network = Network()
    
    static var SERVER: ServerAPI = ServerAPI.VivaCityDocumentationAPIDocumentation
    
    var fullURL: URL {
        switch (Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return  URL.init(string: "\(baseURLString)\(contextPathString)\(path)")!
        case .VivaCityDocumentationAPIDocumentation:
            return  URL.init(string: "\(baseURLString)\(contextPathString)\(path)")!
        }
    }
    
    var fullStringURL: String {
        switch (Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return  "\(baseURLString)\(contextPathString)\(path)"
        case .VivaCityDocumentationAPIDocumentation:
            return  "\(baseURLString)\(contextPathString)\(path)"
        }
    }
    
    var serverURL: URL {
        switch (Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return  URL.init(string: "\(baseURLString)\(contextPathString)")!
        case .VivaCityDocumentationAPIDocumentation:
            return  URL.init(string: "\(baseURLString)\(contextPathString)")!
        }
    }
    
    var baseURLString: String {
        switch (Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return "https://vsmart-api.herokuapp.com" //https://viva-city-documentation.p.rapidapi.com
        case .VivaCityDocumentationAPIDocumentation:
            return "https://viva-city-documentation.p.rapidapi.com"
        }
    }
    
    var contextPathString: String {
        switch (Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return "/api/"
        case .VivaCityDocumentationAPIDocumentation:
            return "/venue-i18n/"
        }
    }
    
    var basePORTString: UInt16 {
        switch(Network.SERVER) {
        case .EdamamFoodAndGroceryDatabase:
            return 8761
        case .VivaCityDocumentationAPIDocumentation:
            return 9898
        }
    }
    
    var path: String {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var method: HTTPMethod {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var parameters: [URLQueryItem]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    var headerFields: [String: String]? {
        fatalError("[\(#function))] Must be overridden in subclass")
    }
    
    func getData(completion: @escaping(Result<Data, Error>) -> Void) {
        var builder = URLComponents(string: fullStringURL)
        builder?.queryItems = parameters
        guard let url = builder?.url else { return }
        var request  = URLRequest(url: url)
        request.httpMethod = method.value
        //        let boundary = "Boundary-\(UUID().uuidString)"
        //    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 30
        
        request.allHTTPHeaderFields = headerFields
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            print("fullURL: ", self.fullStringURL)
            print("params: ", url.queryDictionary as Any)
            print("header: ", self.headerFields as Any)
            print("json: ")
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                let status = httpResponse.statusCode
                
                switch status {
                case 200:
                    break //print("Thanh cong")
                default:
                    break
                }
                
                if !(200...299).contains(httpResponse.statusCode) && !(httpResponse.statusCode == 304) {
                    if let httpError = error {// ... convert httpResponse.statusCode into a more readable error
                        //                        completion(.failure(httpError as! Error))
                        completion(.failure(httpError))
                    }
                }
                
                if let data = data {
                    completion(.success(data))
                    if let json = try? JSON(data: data) {
                        print(json as Any)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func getCategorByAPI(url: String, params: [URLQueryItem]? = nil, headers: [String: String]? = nil, method: HTTPMethod, completion: @escaping(Result<Data, Error>) -> Void) {
        // You might want to stick this into another method
        let url = URL(string: url)!
        var request  = URLRequest(url: url)
        request.httpMethod = method.value
        //        let boundary = "Boundary-\(UUID().uuidString)"
        //    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.allHTTPHeaderFields = headers
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                let status = httpResponse.statusCode
                
                switch status {
                case 200:
                    print("Thanh cong")
                default:
                    break
                }
                
                if !(200...299).contains(httpResponse.statusCode) && !(httpResponse.statusCode == 304) {
                    if let httpError = error {// ... convert httpResponse.statusCode into a more readable error
                        //                        completion(.failure(httpError as! Error))
                        completion(.failure(httpError))
                    }
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
        })
        dataTask.resume()
    }
}
