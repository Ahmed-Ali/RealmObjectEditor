//
//  AttributeNameCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/15/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa
protocol AttributeNameCellDelegate : class{
    func attributeNameDidChange(_ attribute: AttributeDescriptor!, newName: String)
}
class AttributeNameCell: ClickableCell {

    @IBOutlet weak var iconLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!{
        didSet{
            editableLabel = nameLabel
        }
        
    }
    
    weak var delegate : AttributeNameCellDelegate!
    
    var attribute: AttributeDescriptor!{
        didSet{
            iconLabel.stringValue = attribute.type.typeName.getUppercaseOfFirstChar()
            nameLabel.stringValue = attribute.name
        }
    }
    
    
    override func nameDidChange(_ newName: String)
    {
        super.nameDidChange(newName)
        delegate?.attributeNameDidChange(attribute, newName: newName)
    }
    
}
