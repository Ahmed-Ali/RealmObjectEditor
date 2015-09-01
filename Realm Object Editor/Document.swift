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

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)!
        windowController = storyboard.instantiateControllerWithIdentifier("Editor Window Controller") as! NSWindowController
        if let v = windowController.contentViewController as? EditorViewController{
            vc = v
            vc.entities = entities
        }
        self.addWindowController(windowController)
    
    }

    override func dataOfType(typeName: String, error outError: NSErrorPointer) -> NSData? {
    
        var arrayOfDictionaries = [NSDictionary]()
        
        for entityObject in vc.entities{
            let entity = entityObject as EntityDescriptor
            arrayOfDictionaries.append(entity.toDictionary())
        }
        
        let data = NSJSONSerialization.dataWithJSONObject(arrayOfDictionaries, options: .allZeros, error: outError)
        
        return data
    }

    override func readFromData(data: NSData, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
       
        if let arrayOfDictionaries = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: outError) as? [NSDictionary]{
            
            for dictionary in arrayOfDictionaries{
                entities.append(EntityDescriptor(dictionary: dictionary))
            }
            
            return true
        }
        
        return false
    }
    
    
    
}



