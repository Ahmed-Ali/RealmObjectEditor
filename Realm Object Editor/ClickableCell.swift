//
//  ClickableCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/18/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa

class ClickableCell: NSTableCellView, NSTextFieldDelegate{

    var editableLabel : NSTextField!{
        didSet{
            editableLabel.delegate = self
        }
    }
    
    var allowsEmptyValue = false
    var prevName : String = ""
    
    override func mouseUp(theEvent: NSEvent) {
        if editableLabel == nil{
            return
        }
        let globalLocation = theEvent.locationInWindow
        let localLocation = convertPoint(globalLocation, fromView: nil)
        
        if NSPointInRect(localLocation, editableLabel.frame){
            beginEditing()
            
        }else{
            endEditing()
        }
    }
    
    func beginEditing()
    {
        prevName = editableLabel.stringValue
        editableLabel.editable = true
        window?.makeFirstResponder(editableLabel)
    }
    
    func endEditing()
    {
        editableLabel.editable = false
        window?.resignFirstResponder()
        if prevName != editableLabel.stringValue && prevName.characters.count > 0{
            nameDidChange(editableLabel.stringValue)
        }
    }
    
    func nameDidChange(newName: String)
    {
        
        prevName = editableLabel.stringValue
    }
    
    //MARK: - NSTextFieldDelegate
    func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool
    {
        return true
    }
    
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool
    {
        if allowsEmptyValue{
            endEditing()
            return true
        }
        if editableLabel.stringValue.characters.count == 0{
            showEmptyNameError()
            return false
        }
        
        
        endEditing()
        return true
        
    }
    
    func showEmptyNameError()
    {
        let alert = NSAlert()
        alert.messageText = "Name must contain characters"
        alert.addButtonWithTitle("Ok")
        alert.addButtonWithTitle("Discard changes")
        let response = alert.runModal()
        if response == NSAlertSecondButtonReturn{
            //discard changes
            editableLabel.stringValue = prevName
            editableLabel.endEditing(NSText())
            endEditing()
        }
        
    }
}
