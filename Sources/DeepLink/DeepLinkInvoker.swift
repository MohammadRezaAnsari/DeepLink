//
//  DeepLinkInvoker.swift
//  
//
//  Created by MohammadReza Ansary on 10/19/21.
//

import Foundation


public protocol DeepLink {
    
    //Anyhashable should be enum
    // enum should be like vapor -> * / ** / :id and etc.
    var path: [String: AnyHashable]? { get }
    var query: [String: AnyHashable]? { get }
    
    func match(path: [String: AnyHashable]?, query: [String: AnyHashable]?) -> Bool
    
    func executer()
}


public extension DeepLink {
    func match(path: [String: AnyHashable]?, query: [String: AnyHashable]?) -> Bool {
        return (path == self.path && query == self.query)
    }
    
}


struct DeepLinkInvoker {
    
    
    /// Type of available deep links in invoker
    ///
    /// - Note: The builder of each type is evaluated in the order the types appear in this array.
    ///
    private var supportedDeepLinksType: [DeepLink] = [] {
        didSet {
            guard !supportedDeepLinksType.isEmpty else {
                assertionFailure("There is no supported deep link!")
                return
            }
            
            #if DEBUG
            var text = "Deep link support: \n"
            for type in supportedDeepLinksType { text.append("type is  " + String(describing: type.self) + "\n") }
            print("\(text) \n")
            #endif
        }
    }
    
        
    
    // MARK: - ** Public Methods **
    
    
    public func deepLink(matching url: URL) -> [DeepLink] {
        
        var returnValue: [DeepLink] = []
        
        for type in supportedDeepLinksType {
            
            // Match them
            // Get path from url
            // Get query from url
            // Check type is matching with given path and query
            if type.match(path: url.path, query: url.query) { returnValue.append(type) }
        }
        
        return returnValue
    }
    
    

    
    public func appendDeepLinkType(_ type: DeepLink) -> DeepLinkInvoker {
        DeepLinkInvoker(supportedDeepLinksType: supportedDeepLinksType + [type])
    }
    
    public func insertDeepLinkType(_ type: DeepLink, at index: Int) -> DeepLinkInvoker {
        guard supportedDeepLinksType.count >= index else {
            assertionFailure("Could not find index.")
            return DeepLinkInvoker(supportedDeepLinksType: supportedDeepLinksType + [type])
            
        }
        var types = supportedDeepLinksType
        types[index] = type
        return DeepLinkInvoker(supportedDeepLinksType: types)
        
    }
    
    public func deleteDeepLinkType(_ type: DeepLink) -> DeepLinkInvoker {
        guard supportedDeepLinksType.contains(where: { $0 == type }) else {
            return self
        }
        var types = supportedDeepLinksType
        types.removeAll(where: { $0 == type })
        return DeepLinkInvoker(supportedDeepLinksType: types)
    }
    
    public func removeAllDeepLinkType() -> DeepLinkInvoker {
        DeepLinkInvoker(supportedDeepLinksType: [])
    }
}






extension URL {
        
    var path: [String: AnyHashable]? {
        
        return nil
    }
    
    
    var query: [String: AnyHashable]? {
        
        return nil
    }
}
