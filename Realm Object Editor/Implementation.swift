//
//	Implementation.swift
//
//	Create by Ahmed Ali on 24/1/2015
//	Copyright © 2015 Ahmed Ali Individual Mobile Developer. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Implementation : NSObject{

	var defaultValuesDefination : String!
	var fileExtension : String!
	var forEachIgnoredProperty : String!
	var forEachIndexedAttribute : String!
	var forEachPropertyWithDefaultValue : String!
	var headerImport : String!
	var ignoredProperties : String!
	var indexedAttributesDefination : String!
	var modelDefinition : String!
	var modelEnd : String!
	var modelStart : String!
	var primaryKeyDefination : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		defaultValuesDefination = dictionary["defaultValuesDefination"] as? String
		fileExtension = dictionary["fileExtension"] as? String
		forEachIgnoredProperty = dictionary["forEachIgnoredProperty"] as? String
		forEachIndexedAttribute = dictionary["forEachIndexedAttribute"] as? String
		forEachPropertyWithDefaultValue = dictionary["forEachPropertyWithDefaultValue"] as? String
		headerImport = dictionary["headerImport"] as? String
		ignoredProperties = dictionary["ignoredProperties"] as? String
		indexedAttributesDefination = dictionary["indexedAttributesDefination"] as? String
		modelDefinition = dictionary["modelDefinition"] as? String
		modelEnd = dictionary["modelEnd"] as? String
		modelStart = dictionary["modelStart"] as? String
		primaryKeyDefination = dictionary["primaryKeyDefination"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if defaultValuesDefination != nil{
			dictionary["defaultValuesDefination"] = defaultValuesDefination
		}
		if fileExtension != nil{
			dictionary["fileExtension"] = fileExtension
		}
		if forEachIgnoredProperty != nil{
			dictionary["forEachIgnoredProperty"] = forEachIgnoredProperty
		}
		if forEachIndexedAttribute != nil{
			dictionary["forEachIndexedAttribute"] = forEachIndexedAttribute
		}
		if forEachPropertyWithDefaultValue != nil{
			dictionary["forEachPropertyWithDefaultValue"] = forEachPropertyWithDefaultValue
		}
		if headerImport != nil{
			dictionary["headerImport"] = headerImport
		}
		if ignoredProperties != nil{
			dictionary["ignoredProperties"] = ignoredProperties
		}
		if indexedAttributesDefination != nil{
			dictionary["indexedAttributesDefination"] = indexedAttributesDefination
		}
		if modelDefinition != nil{
			dictionary["modelDefinition"] = modelDefinition
		}
		if modelEnd != nil{
			dictionary["modelEnd"] = modelEnd
		}
		if modelStart != nil{
			dictionary["modelStart"] = modelStart
		}
		if primaryKeyDefination != nil{
			dictionary["primaryKeyDefination"] = primaryKeyDefination
		}
		return dictionary
	}

}