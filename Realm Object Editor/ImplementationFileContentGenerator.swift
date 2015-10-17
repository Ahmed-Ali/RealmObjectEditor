//
//  ImplementationFileContentGenerator.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/24/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//


class ImplementationFileContentGenerator: FileContentGenerator {
    
    
    override func getFielContent() -> String
    {
        appendCopyrights(entity.name, fileExtension: lang.implementation.fileExtension)
        content += lang.implementation.headerImport
        
        content += lang.implementation.modelDefinition
        content += lang.implementation.modelStart
        content.replace(EntityName, by: entity.name)
        
        appendIndexedAttributes(lang.implementation.indexedAttributesDefination, forEachIndexedAttribute: lang.implementation.forEachIndexedAttribute)
        appendPrimaryKey(lang.implementation.primaryKeyDefination)
        appendDefaultValues()
        appendIgnoredProperties(lang.implementation.ignoredProperties, forEachIgnoredProperty: lang.implementation.forEachIgnoredProperty)
        
        
        content += lang.implementation.modelEnd
        return content
        
    }
    
    //MARK: - Default Values
    func appendDefaultValues()
    {
        var defValues = ""
        let types = lang.dataTypes.toDictionary()
        for attr in entity.attributes{
            if !attr.hasDefault{
                continue
            }
            let defValue = defaultValueForAttribute(attr, types: types)
            if attr.defaultValue.characters.count == 0{
                continue
            }
            
            var defValueDefination = lang.implementation.forEachPropertyWithDefaultValue
            defValueDefination.replace(AttrName, by: attr.name)
            defValueDefination.replace(AttrDefaultValue, by: defValue)
            defValues += defValueDefination
        }
        
        if defValues.characters.count > 0{
            var defValuesDef = lang.implementation.defaultValuesDefination
            defValuesDef.replace(DefaultValues, by: defValues)
            content += defValuesDef
        }
    }
    
    
}
