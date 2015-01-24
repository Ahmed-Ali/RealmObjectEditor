//
//  EntitiesContentGenerator.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/20/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Foundation
class EntityFilesGenerator {
    /**
    Lazely load and return the singleton instance of the EntityGenerator
    */
    
    class var instance : EntityFilesGenerator {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : EntityFilesGenerator? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = EntityFilesGenerator()
        }
        return Static.instance!
    }
    
    
    func entitiesToFiles(entities: [EntityDescriptor], lang: LangModel) -> [FileModel]
    {
        var files = [FileModel]()
        for entity in entities{
            let file = FileModel()
            file.fileName = entity.name
            file.fileExtension = lang.fileExtension
            file.fileContent = FileContentGenerator(entity: entity, lang: lang).getFielContent()
            files.append(file)
            if lang.implementation != nil{
                //This language also provides a seperate implementation file
                let implementationFile = FileModel()
                implementationFile.fileName = entity.name
                implementationFile.fileExtension = lang.implementation.fileExtension
                implementationFile.fileContent = ImplementationFileContentGenerator(entity: entity, lang: lang).getFielContent()
                files.append(implementationFile)
            }
        }
        return files
    }
    
    
    func fileContentForEntity(entity: EntityDescriptor, lang: LangModel) -> String
    {
        var contentGenerator = FileContentGenerator(entity: entity, lang: lang)
        
        return FileContentGenerator(entity: entity, lang: lang).getFielContent()
    }
    
    func headerFileContentForEntity(entity: EntityDescriptor, lang: LangModel) -> String
    {
        return ""
    }
    
    
    
}