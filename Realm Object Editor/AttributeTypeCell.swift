//
//  AttributeTypeCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/15/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa

protocol AttributeTypeCellDelegate : class
{
    func attributeTypeDidChange(attribute attribute: AttributeDescriptor)
}

class AttributeTypeCell: NSTableCellView {

    weak var delegate : AttributeTypeCellDelegate!
    
    var attribute : AttributeDescriptor!{
        didSet{
            
            typesPopupButton.selectItemWithTitle(attribute.type.typeName)
        }
    }
    
    @IBOutlet weak var typesPopupButton: NSPopUpButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        typesPopupButton.removeAllItems()
        typesPopupButton.addItemsWithTitles(supportedTypesAsStringsArray())
    }
    
    
    @IBAction func changeType(sender: AnyObject)
    {
        attribute.type = arrayOfSupportedTypes[typesPopupButton.indexOfSelectedItem]
        delegate?.attributeTypeDidChange(attribute: attribute)
    }
    
}
