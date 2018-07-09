//
//  TypeDescriptor.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//


//Supported types
//BOOL, bool, int, NSInteger, long, long long, float, double, CGFloat, NSString, NSDate, and NSData
import Foundation

//var allTypeStrings : [String]{
//    return ["Undefined",
//        "Bool",
//        "Int",
//        "Long",
//        "Float",
//        "Double",
//        "String",
//        "NSDate",
//        "NSData"]
//}




//MARK: - Helpers
let NoDefaultValue = "<!#NoDefault#!>"

let arrayOfSupportedTypes : [TypeDescriptor] = [InvalidType(),
    IntType(),
    LongType(),
    FloatType(),
    DoubleType(),
    StringType(),
    DateType(),
    BinaryDataType(),
    BoolType()]

func indexOfType(_ type : TypeDescriptor) -> Int?
{
    for i in 0 ..< arrayOfSupportedTypes.count{
        let t = arrayOfSupportedTypes[i]
        if t.techName == type.techName{
            return i
        }
    }
    
    return nil
}

func supportedTypesAsStringsArray() -> [String]
{
    let typesAsStrings = arrayOfSupportedTypes.map {
        (type) -> String in
        type.typeName
    }
    
    return typesAsStrings
}

func findTypeByTypeName(_ typeName: String) -> TypeDescriptor?
{
    for type in arrayOfSupportedTypes{
        if type.typeName == typeName{
            return type
        }
    }
    
    return nil
}

//MARK: - Types
@objc protocol TypeDescriptor {
    var typeName : String {get}
    var techName : String {get}
    var canBePrimaryKey : Bool {get}
    var defaultValue : String {get}
    
    
}


class BaseType : NSObject, TypeDescriptor
{
    var typeName : String {
        return "undefined"
    }
    var techName : String{
        return "undefined"
    }
    var defaultValue : String{
        return NoDefaultValue
    }
    var canBePrimaryKey : Bool{
        return false
    }
    
    
}

class InvalidType : BaseType
{
    
}

class BoolType : BaseType
{
    
    override var typeName : String {
        return "Bool"
    }
    override var techName : String{
        return "boolType"
    }

    override var defaultValue : String{
        return "false"
    }
    
    
}



class IntType : BaseType
{
    override var typeName : String {
        return "Integer"
    }
    override var techName : String{
        return "intType"
    }
    
    override var canBePrimaryKey : Bool{
        return true
    }
    
    override var defaultValue : String{
        return "0"
    }
    
   
}

class LongType : BaseType
{
    override var typeName : String {
        return "Long"
    }
    override var techName : String{
        return "longType"
    }
    
    
    override var defaultValue : String{
        return "0"
    }
    
}

class FloatType : BaseType
{
    override var typeName : String {
        return "Float"
    }
    override var techName : String{
        return "floatType"
    }
   
    
    override var defaultValue : String{
        return "0.0"
    }
    
}


class DoubleType : BaseType
{
    override var typeName : String {
        return "Double"
    }
    override var techName : String{
        return "doubleType"
    }
    
    override var defaultValue : String{
        return "0"
    }
}

class StringType : BaseType
{
    override var typeName : String {
        return "String"
    }
    override var techName : String{
        return "stringType"
    }
    override var defaultValue : String{
        return ""
    }
    override var canBePrimaryKey : Bool{
        return true
    }
    
    
}

class DateType : BaseType
{
    override var typeName : String {
        return "Date"
    }
    override var techName : String{
        return "dateType"
    }
    
}

class BinaryDataType : BaseType
{
    override var typeName : String {
        return "Binary Data"
    }
    
    override var techName : String{
        return "dataType"
    }
}

