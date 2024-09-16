//
//  File.swift
//  
//
//  Created by Hanan Ahmed on 16/09/2024.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

public class CountryListRequest : SmilesBaseMainRequest {
    
    public var firstCallFlag : Bool?
    public var lastModifiedDate : String?
    
    public enum CountryListResponseCodingKeys: String, CodingKey {
        case countryList = "firstCallFlag"
        case lastModifiedDate = "lastModifiedDate"
    }
    
    public override init() {
        super.init()
        self.firstCallFlag = true
        self.lastModifiedDate = ""
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CountryListResponseCodingKeys.self)
        try container.encode(firstCallFlag, forKey: .countryList)
        try container.encode(lastModifiedDate, forKey: .lastModifiedDate)
    }
    
    public func asDictionary(dictionary :[String : Any] = [:]) -> [String : Any] {
        
        let encoder = DictionaryEncoder()
        guard  let encoded = try? encoder.encode(self) as [String:Any]  else {
            return [:]
        }
        return encoded.mergeDictionaries(dictionary:dictionary)
        
    }
    
}
