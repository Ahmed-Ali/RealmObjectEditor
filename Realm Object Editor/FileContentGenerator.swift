//
//  FileContentGenerator.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/20/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Foundation
import AddressBook

class FileContentGenerator {
    
    var content = ""
    var entity: EntityDescriptor
    var lang: LangModel
    
    init(entity: EntityDescriptor, lang: LangModel)
    {
        self.entity = entity
        self.lang = lang
    }
    
    
    func getFielContent() -> String
    {
        appendCopyrights(entity.name, fileExtension: lang.fileExtension)
        appendStaticImports()
        appendRelationshipImports()
        content += lang.modelDefinition
        content += lang.modelStart
        content.replace(EntityName, by: entity.name)
        if entity.superClassName.characters.count == 0{
            content.replace(ParentName, by: lang.defaultSuperClass)
        }else{
            content.replace(ParentName, by: entity.superClassName)
        }
        appendAttributes()
        appendRelationships()
        if lang.primaryKeyDefination != nil{
            appendPrimaryKey(lang.primaryKeyDefination)
        }
        if lang.indexedAttributesDefination != nil && lang.forEachIndexedAttribute != nil{
            appendIndexedAttributes(lang.indexedAttributesDefination, forEachIndexedAttribute: lang.forEachIndexedAttribute)
        }
        if lang.ignoredProperties != nil && lang.forEachIgnoredProperty != nil{
            appendIgnoredProperties(lang.ignoredProperties, forEachIgnoredProperty: lang.forEachIgnoredProperty)
        }
        if lang.getter != nil && lang.setter != nil{
            appendGettersAndSetters(lang.getter, setter: lang.setter)
        }
        
        content += lang.modelEnd
        content.replace(EntityName, by: entity.name)
        return content
        
    }
    
    //MARK: - Setter and Getters
    func appendGettersAndSetters(getter: String, setter: String)
    {
        let types = lang.dataTypes.toDictionary()
        for attr in entity.attributes{
            appendDefination(getter, attrName: attr.name, attrType: types[attr.type.techName]!)
            appendDefination(setter, attrName: attr.name, attrType: types[attr.type.techName]!)
        }
        
        for relationship in entity.relationships{
            var type = relationship.destinationName
            if relationship.toMany && lang.toManyRelationType != nil{
                var relationshipType = lang.toManyRelationType
                relationshipType.replace(RelationshipType, by: type)
                type = relationshipType
            }
            appendDefination(getter, attrName: relationship.name, attrType: type)
            appendDefination(setter, attrName: relationship.name, attrType: type)
        }
    }
    
    func appendDefination(defination: String, attrName: String, attrType: String)
    {
        var def = defination
        def.replace(AttrName, by: attrName)
        def.replace(AttrType, by: attrType)
        def.replace(CapitalizedAttrName, by: attrName.uppercaseFirstChar())
        content += def
    }
    
    //MARK: - Ignored properties
    func appendIgnoredProperties(ignoredPropertiesDef: String, forEachIgnoredProperty: String)
    {
        let types = lang.dataTypes.toDictionary()
        var ignoredAttrs = ""
        for attr in entity.attributes{
            if attr.ignored{
                var ignored = forEachIgnoredProperty
                ignored.replace(AttrName, by: attr.name)
                ignored.replace(AttrType, by: types[attr.type.techName]!)
                ignoredAttrs += ignored
            }
        }
        
        if ignoredAttrs.characters.count > 0{
            var ignoredAttrDef = ignoredPropertiesDef
            ignoredAttrDef.replace(IgnoredAttributes, by: ignoredAttrs)
            content += ignoredAttrDef
        }
    }
    
    //MARK: - Primary Key
    func appendPrimaryKey(primaryKeyDef: String)
    {
        let types = lang.dataTypes.toDictionary()
        for attr in entity.attributes{
            if attr.isPrimaryKey{
                var def = primaryKeyDef
                def.replace(AttrName, by: attr.name)
                def.replace(AttrType, by: types[attr.type.techName]!)
                content += def
                break
            }
        }
    }
    
    
    //MARK: - Index Attributes
    func appendIndexedAttributes(indexAttributesDefination: String, forEachIndexedAttribute: String)
    {
        let types = lang.dataTypes.toDictionary()
        var indexedAttrs = ""
        for attr in entity.attributes{
            if attr.indexed{
                var indexed = forEachIndexedAttribute
                indexed.replace(AttrName, by: attr.name)
                indexed.replace(AttrType, by: types[attr.type.techName]!)
                indexedAttrs += indexed
            }
        }
        
        if indexedAttrs.characters.count > 0{
            var indexedAttrDef = indexAttributesDefination
            indexedAttrDef.replace(IndexedAttributes, by: indexedAttrs)
            content += indexedAttrDef
        }
    }
    
    //MARK: - Relationships
    func appendRelationships()
    {
        for (index, relationship) in entity.relationships.enumerate(){
            var relationshipDef = ""
            if relationship.toMany{
                relationshipDef = lang.toManyRelationshipDefination
            }else{
                relationshipDef = lang.toOneRelationshipDefination
            }
            
            relationshipDef.replace(RelationshipName, by: relationship.name)
            relationshipDef.replace(RelationshipType, by: relationship.destinationName)
            
            if lang.modelDefineInConstructor != nil{
                relationshipDef.replace(Seperator, by: getSeperator(index, total: entity.relationships.count))
            }
            
            content += relationshipDef
        }
        
    }
    
    //MARK: - Attributes
    func appendAttributes()
    {
        let types = lang.dataTypes.toDictionary()
        for (index, attr) in entity.attributes.enumerate(){
            
            var attrDefination = ""
            if lang.attributeDefinationWithDefaultValue != nil && lang.attributeDefinationWithDefaultValue.characters.count > 0 && attr.hasDefault{
                attrDefination = lang.attributeDefinationWithDefaultValue
                
                let defValue = defaultValueForAttribute(attr, types: types)
                
                attrDefination.replace(AttrDefaultValue, by: defValue)
                
            }else{
                attrDefination = lang.attributeDefination
            }
            
            attrDefination.replace(AttrName, by: attr.name)
            attrDefination.replace(AttrType, by: types[attr.type.techName]!)
            var annotations = ""
            
            if attr.isPrimaryKey{
                if lang.primaryKeyAnnotation != nil{
                    annotations += lang.primaryKeyAnnotation
                }
            }
            
            if attr.indexed{
                if lang.indexAnnotaion != nil{
                    annotations += lang.indexAnnotaion
                }
            }
            
            
            if attr.ignored{
                if lang.ignoreAnnotaion != nil{
                    annotations += lang.ignoreAnnotaion
                }
            }
            
            attrDefination.replace(Annotations, by: annotations)
            
            if lang.modelDefineInConstructor != nil{
                let totalItems = entity.attributes.count + entity.relationships.count
                attrDefination.replace(Seperator, by: getSeperator(index, total: totalItems))
            }

            content += attrDefination
        }
    }
    
    func getSeperator(index: Int, total: Int) -> String
    {
        return (index < total - 1) ? "," : ""
    }
    
    
    func defaultValueForAttribute(attribute: AttributeDescriptor, types: [String : String]) -> String
    {
        var defValue = attribute.defaultValue
        if defValue == NoDefaultValue{
            if let def = types["\(attribute.type.techName)DefaultValue"]{
                defValue = def
            }else{
                defValue = ""
            }
        }else{
            if var quoutedValue = types["\(attribute.type.techName)QuotedValue"]{
                quoutedValue.replace(QuotedValue, by: attribute.defaultValue)
                
                defValue = quoutedValue
            }
        }
        
        return defValue
    }
    
    //MARK: Imports
    func appendStaticImports()
    {
        if lang.staticImports != nil{
            content += lang.staticImports
        }
    }
    
    func appendRelationshipImports()
    {
        if lang.relationsipImports != nil{
            for r in entity.relationships{
                var relationshipImport = lang.relationsipImports
                relationshipImport.replace(RelationshipType, by: r.destinationName)
                content += relationshipImport
            }
        }
    }
    
    //MARK: - Copyrights
    func appendCopyrights(fileName: String, fileExtension: String)
    {
        content += "//\n//\t\(fileName).\(fileExtension)\n"
        if let me = ABAddressBook.sharedAddressBook()?.me(){
            
            if let firstName = me.valueForProperty(kABFirstNameProperty as String) as? String{
                content += "//\n//\tCreate by \(firstName)"
                if let lastName = me.valueForProperty(kABLastNameProperty as String) as? String{
                    content += " \(lastName)"
                }
            }
            
            
            content += " on \(getTodayFormattedDay())\n//\tCopyright © \(getYear())"
            
            if let organization = me.valueForProperty(kABOrganizationProperty as String) as? String{
                content += " \(organization)"
            }
            
            content += ". All rights reserved.\n"
        }
        
        content += "//\tModel file Generated using Realm Object Editor: https://github.com/Ahmed-Ali/RealmObjectEditor\n\n"
    }
    
    
    /**
    Returns the current year as String
    */
    func getYear() -> String
    {
        return "\(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()))"
    }
    
    /**
    Returns today date in the format dd/mm/yyyy
    */
    func getTodayFormattedDay() -> String
    {
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: NSDate())
        return "\(components.day)/\(components.month)/\(components.year)"
    }
}