import SwiftyJSON

//extension URLSession {
//
//    enum HTTPError: Error {
//        case transportError(Error)
//        case serverSideError(Int)
//    }
//
//    typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>
//
//    func dataTask(with request: URLRequest, completionHandler: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
//        return self.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completionHandler(Result.failure(HTTPError.transportError(error)))
//                return
//            }
//            let response = response as! HTTPURLResponse
//            let status = response.statusCode
//            guard (200...299).contains(status) else {
//                completionHandler(Result.failure(HTTPError.serverSideError(status)))
//                return
//            }
//            completionHandler(Result.success((response, data!)))
//        }
//    }
//}

import Foundation

enum HTTPMethod {
    case get
    case post
    case put
    
    var value: String {
        get {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            }
        }
    }
}

class BaseRouter {
    static let shared: BaseRouter = BaseRouter()
    
    func getData<T: Codable>(urlString: String, params: [URLQueryItem]? = nil, headers: [String: String]? = nil, method: HTTPMethod, completion: @escaping(T)->()) {
        var urlBuilder = URLComponents(string: urlString)
        urlBuilder?.queryItems = params
        
        guard let url = urlBuilder?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.value
        urlRequest.cachePolicy = .useProtocolCachePolicy
        urlRequest.timeoutInterval = 30.0
        urlRequest.allHTTPHeaderFields = headers
        //        urlRequest.setValue("value", forHTTPHeaderField: "key")
        let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            
            if let data = data {
                print("fullURLRequest: ", url)
                print("params: ", url.query as Any)
                print("header: ", url.absoluteURL)
                if let json = try? JSON(data: data) {
                    print("Response json:\n", json as Any)
                }
            }
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(data)
                }
            } catch let error {
                print("decode error: ", error)
            }
        })
        dataTask.resume()
    }
}

//extension URLSession {
//    
//    enum HTTPError: Error {
//        case transportError(Error)
//        case serverSideError(Int)
//    }
//    
//    typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>
//    
//    func dataTask(with request: URLRequest, completionHandler: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
//        return self.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completionHandler(Result.failure(HTTPError.transportError(error)))
//                return
//            }
//            let response = response as! HTTPURLResponse
//            let status = response.statusCode
//            guard (200...299).contains(status) else {
//                completionHandler(Result.failure(HTTPError.serverSideError(status)))
//                return
//            }
//            completionHandler(Result.success((response, data!)))
//        }
//    }
//}
