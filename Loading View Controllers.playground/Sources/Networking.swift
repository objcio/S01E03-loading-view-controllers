import Foundation


public struct Episode {
    public var id: String
    public var title: String
    
    public init(id: String, title: String) {
        self.id =  id
        self.title =  title
    }
}


public typealias JSONDictionary = [String: AnyObject]

extension Episode {
    public init?(json: JSONDictionary) {
        guard let id = json["id"] as? String,
            let title = json["title"] as? String else { return nil }
        
        self.id = id
        self.title = title
    }
}


public struct Resource<A> {
    public var url: URL
    public var parse: (Data) -> A?
}

extension Resource {
    public init(url: URL, parseJSON: @escaping (AnyObject) -> A?) {
        self.url = url
        self.parse = { data in
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            return json.flatMap(parseJSON)
        }
    }
}


public enum Result<A> {
    case success(A)
    case error(Error)
}

extension Result {
    public init(_ value: A?, or error: Error) {
        if let value = value {
            self = .success(value)
        } else {
            self = .error(error)
        }
    }
    
    public var value: A? {
        guard case .success(let v) = self else { return nil }
        return v
    }
}


public enum WebserviceError: Error {
    case other
}


public final class Webservice {
    public init() { }
    
    /// Loads a resource. The completion handler is always called on the main queue.
    public func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url, completionHandler: { data, response, _ in
            let parsed = data.flatMap(resource.parse)
            let result = Result(parsed, or: WebserviceError.other)
            mainQueue { completion(result) }
        }) .resume()
    }
}
