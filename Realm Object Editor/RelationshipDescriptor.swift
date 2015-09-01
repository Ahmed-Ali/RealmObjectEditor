//
//  RelationDescriptor.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Foundation


class RelationshipDescriptor : NSObject{
    var name: String
    var destinationName : String!
    var toMany = false
    
    
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as! String
        toMany = dictionary["toMany"] as! Bool
        destinationName = dictionary["destinationName"] as? String
        super.init()
    }
    
    init(name: String)
    {
        self.name = name
        super.init()
    }
    
    func toDictionary() -> NSDictionary
    {
        var dictionary : NSDictionary!
        if destinationName != nil{
            dictionary = ["name" : name, "toMany" : toMany, "destinationName" : destinationName]
        }else{
            dictionary = ["name" : name, "toMany" : toMany]
        }
        
        return dictionary
    }
    
    
}