//
//  Document.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    var vc : EditorViewController!
    var windowController: NSWindowController!
    var entities = [EntityDescriptor]()
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Editor Window Controller")) as! NSWindowController
        if let v = windowController.contentViewController as? EditorViewController{
            vc = v
            vc.entities = entities
        }
        self.addWindowController(windowController)
    
    }

    override func data(ofType typeName: String) throws -> Data {
        var outError: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
    
        var arrayOfDictionaries = [NSDictionary]()
        
        for entityObject in vc.entities{
            let entity = entityObject as EntityDescriptor
            arrayOfDictionaries.append(entity.toDictionary())
        }
        
        let data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: arrayOfDictionaries, options: [])
        } catch let error as NSError {
            outError = error
            data = nil
        }
        
        if let value = data {
            return value
        }
        throw outError
    }

    override func read(from data: Data, ofType typeName: String) throws {
        let outError: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
       
        if let arrayOfDictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]{
            
            for dictionary in arrayOfDictionaries{
                entities.append(EntityDescriptor(dictionary: dictionary))
            }
            
            return
        }
        
        throw outError
    }
    
    
    
}



