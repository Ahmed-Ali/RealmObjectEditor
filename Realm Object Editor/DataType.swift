//
//	DataType.swift
//
//	Create by Ahmed Ali on 23/1/2015
//	Copyright © 2015 Ahmed Ali Individual Mobile Developer. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class DataType : NSObject{
    
    var boolType : String!
    var boolTypeQuotedValue : String!
    var dataType : String!
    var dataTypeDefaultValue : String!
    var dateType : String!
    var dateTypeDefaultValue : String!
    var doubleType : String!
    var doubleTypeQuotedValue : String!
    var floatType : String!
    var floatTypeQuotedValue : String!
    var intType : String!
    var intTypeQuotedValue : String!
    var longType : String!
    var longTypeQuotedValue : String!
    var stringType : String!
    var stringTypeQuotedValue : String!
    
    
    /**
    * Instantiate the instance using the passed dictionary values to set the properties values
    */
    init(fromDictionary dictionary: NSDictionary){
        boolType = dictionary["boolType"] as? String
        boolTypeQuotedValue = dictionary["boolTypeQuotedValue"] as? String
        dataType = dictionary["dataType"] as? String
        dataTypeDefaultValue = dictionary["dataTypeDefaultValue"] as? String
        dateType = dictionary["dateType"] as? String
        dateTypeDefaultValue = dictionary["dateTypeDefaultValue"] as? String
        doubleType = dictionary["doubleType"] as? String
        doubleTypeQuotedValue = dictionary["doubleTypeQuotedValue"] as? String
        floatType = dictionary["floatType"] as? String
        floatTypeQuotedValue = dictionary["floatTypeQuotedValue"] as? String
        intType = dictionary["intType"] as? String
        intTypeQuotedValue = dictionary["intTypeQuotedValue"] as? String
        longType = dictionary["longType"] as? String
        longTypeQuotedValue = dictionary["longTypeQuotedValue"] as? String
        stringType = dictionary["stringType"] as? String
        stringTypeQuotedValue = dictionary["stringTypeQuotedValue"] as? String
    }
    
    /**
    * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
    */
    func toDictionary() -> [String : String]
    {
        var dictionary = [String : String]()
        if boolType != nil{
            dictionary["boolType"] = boolType
        }
        if boolTypeQuotedValue != nil{
            dictionary["boolTypeQuotedValue"] = boolTypeQuotedValue
        }
        if dataType != nil{
            dictionary["dataType"] = dataType
        }
        if dataTypeDefaultValue != nil{
            dictionary["dataTypeDefaultValue"] = dataTypeDefaultValue
        }
        if dateType != nil{
            dictionary["dateType"] = dateType
        }
        if dateTypeDefaultValue != nil{
            dictionary["dateTypeDefaultValue"] = dateTypeDefaultValue
        }
        if doubleType != nil{
            dictionary["doubleType"] = doubleType
        }
        if doubleTypeQuotedValue != nil{
            dictionary["doubleTypeQuotedValue"] = doubleTypeQuotedValue
        }
        if floatType != nil{
            dictionary["floatType"] = floatType
        }
        if floatTypeQuotedValue != nil{
            dictionary["floatTypeQuotedValue"] = floatTypeQuotedValue
        }
        if intType != nil{
            dictionary["intType"] = intType
        }
        if intTypeQuotedValue != nil{
            dictionary["intTypeQuotedValue"] = intTypeQuotedValue
        }
        if longType != nil{
            dictionary["longType"] = longType
        }
        if longTypeQuotedValue != nil{
            dictionary["longTypeQuotedValue"] = longTypeQuotedValue
        }
        if stringType != nil{
            dictionary["stringType"] = stringType
        }
        if stringTypeQuotedValue != nil{
            dictionary["stringTypeQuotedValue"] = stringTypeQuotedValue
        }
        
        return dictionary
    }
}