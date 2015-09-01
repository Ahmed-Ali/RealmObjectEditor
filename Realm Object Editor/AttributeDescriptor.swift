//
//  PropertyDescriptor.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Foundation
class AttributeDescriptor: NSObject {
    var name : String
    var ignored = false
    var indexed = false
    //Only string and int attributes can be primary
    var isPrimaryKey = false
    var hasDefault = false
    var defaultValue = ""
    
    var type : TypeDescriptor = InvalidType(){
        didSet{
            defaultValue = NoDefaultValue
            hasDefault = false
        }
    }
    
   
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as! String
        ignored = dictionary["ignored"] as! Bool
        indexed = dictionary["indexed"] as! Bool
        isPrimaryKey = dictionary["isPrimaryKey"] as! Bool
        hasDefault = dictionary["hasDefault"] as! Bool
        defaultValue = dictionary["defaultValue"] as! String
        let tName = dictionary["typeName"] as! String
        if let t = findTypeByTypeName(tName){
            type = t
        }
        super.init()
    }
    
    init(name: String)
    {
        self.name = name
        super.init()
    }
    
    func toDictionary() -> NSDictionary
    {
        var dictionary = ["name" : name,
            "ignored" : ignored,
            "indexed" : indexed,
            "isPrimaryKey" : isPrimaryKey,
            "hasDefault" : hasDefault,
            "defaultValue" : defaultValue,
            "typeName" : type.typeName
        ]
        
        return dictionary
    }
}