//
//  EntityDescriptor.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Foundation


class EntityDescriptor: NSObject{
    var name : String
    var superClassName = ""
    var attributes = [AttributeDescriptor]()
    var relationships = [RelationshipDescriptor]()
    
    
    
    init(name: String)
    {
        self.name = name
        super.init()
    }
    
    init(dictionary: NSDictionary)
    {
        name = dictionary["name"] as! String
        superClassName = dictionary["superClassName"] as! String
        if let attrs = dictionary["attributes"] as? [NSDictionary]{
            for attr in attrs{
                attributes.append(AttributeDescriptor(dictionary: attr))
            }
        }
        
        if let relations = dictionary["relationships"] as? [NSDictionary]{
            for r in relations{
                relationships.append(RelationshipDescriptor(dictionary: r))
            }
        }
        
    }
    
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        dictionary["name"] = name
        dictionary["superClassName"] = superClassName
        var attrs = [NSDictionary]()
        for attr in attributes{
            attrs.append(attr.toDictionary())
        }
        var relations = [NSDictionary]()
        for r in relationships{
            relations.append(r.toDictionary())
        }
        
        dictionary["attributes"] = attrs
        dictionary["relationships"] = relations
        return dictionary
    }
}

