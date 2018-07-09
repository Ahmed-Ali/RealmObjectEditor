//
//  EntitiesContentGenerator.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/20/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Foundation
class EntityFilesGenerator {
    

    static let instance = EntityFilesGenerator()
    
    func entitiesToFiles(_ entities: [EntityDescriptor], lang: LangModel) -> [FileModel]
    {
        var files = [FileModel]()
        for entity in entities{
            let file = FileModel()
            file.fileName = entity.name
            file.fileExtension = lang.fileExtension
            file.fileContent = FileContentGenerator(entity: entity, lang: lang).getFileContent()
            files.append(file)
            if lang.implementation != nil{
                //This language also provides a seperate implementation file
                let implementationFile = FileModel()
                implementationFile.fileName = entity.name
                implementationFile.fileExtension = lang.implementation.fileExtension
                implementationFile.fileContent = ImplementationFileContentGenerator(entity: entity, lang: lang).getFileContent()
                files.append(implementationFile)
            }
        }
        return files
    }
    
    
    func fileContentForEntity(_ entity: EntityDescriptor, lang: LangModel) -> String
    {
        
        return FileContentGenerator(entity: entity, lang: lang).getFileContent()
    }
    
    func headerFileContentForEntity(_ entity: EntityDescriptor, lang: LangModel) -> String
    {
        return ""
    }
    
    
    
}
