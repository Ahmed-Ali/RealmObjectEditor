//
//	LangModel.swift
//
//	Create by Ahmed Ali on 24/1/2015
//	Copyright © 2015 Ahmed Ali Individual Mobile Developer. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class LangModel : NSObject{

	var attributeDefination : String!
	var attributeDefinationWithDefaultValue : String!
	var dataTypes : DataType!
    var defaultSuperClass: String!
	var fileExtension : String!
    var firstLineStatement : Bool!
	var forEachIgnoredProperty : String!
	var forEachIndexedAttribute : String!
    var getter : String!
	var ignoredProperties : String!
    var ignoreAnnotaion : String!
	var implementation : Implementation!
	var indexedAttributesDefination : String!
    var indexAnnotaion: String!
	var modelDefinition : String!
    var modelDefineInConstructor: Bool!
	var modelEnd : String!
	var modelStart : String!
	var primaryKeyDefination : String!
	var relationsipImports : String!
    var setter: String!
	var staticImports : String!
	var toManyRelationshipDefination : String!
    var toManyRelationType : String!
	var toOneRelationshipDefination : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		attributeDefination = dictionary["attributeDefination"] as? String
		attributeDefinationWithDefaultValue = dictionary["attributeDefinationWithDefaultValue"] as? String
		if let dataTypesData = dictionary["dataTypes"] as? NSDictionary{
			dataTypes = DataType(fromDictionary: dataTypesData)
		}
        defaultSuperClass = dictionary["defaultSuperClass"] as? String
		fileExtension = dictionary["fileExtension"] as? String
        firstLineStatement = dictionary["firstLineStatement"] as? Bool
		forEachIgnoredProperty = dictionary["forEachIgnoredProperty"] as? String
		forEachIndexedAttribute = dictionary["forEachIndexedAttribute"] as? String
        getter = dictionary["getter"] as? String
        ignoreAnnotaion = dictionary["ignoreAnnotaion"] as? String
		ignoredProperties = dictionary["ignoredProperties"] as? String
        
		if let implementationData = dictionary["implementation"] as? NSDictionary{
			implementation = Implementation(fromDictionary: implementationData)
		}
		indexedAttributesDefination = dictionary["indexedAttributesDefination"] as? String
        indexAnnotaion = dictionary["indexAnnotaion"] as? String
        modelDefineInConstructor = dictionary["modelDefineInConstructor"] as? Bool
		modelDefinition = dictionary["modelDefinition"] as? String
		modelEnd = dictionary["modelEnd"] as? String
		modelStart = dictionary["modelStart"] as? String
		primaryKeyDefination = dictionary["primaryKeyDefination"] as? String
        
		relationsipImports = dictionary["relationsipImports"] as? String
        setter = dictionary["setter"] as? String
		staticImports = dictionary["staticImports"] as? String
		toManyRelationshipDefination = dictionary["toManyRelationshipDefination"] as? String
        toManyRelationType = dictionary["toManyRelationType"] as? String
		toOneRelationshipDefination = dictionary["toOneRelationshipDefination"] as? String
        
	}

	

}