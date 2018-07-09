//
//  RelationshipNameCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/17/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa
protocol RelationshipNameCellDelegate : class{
    func relationshipNameDidChange(_ relationship: RelationshipDescriptor!, newName: String)
}
class RelationshipNameCell: ClickableCell {

    weak var delegate : RelationshipNameCellDelegate!
    var relationship: RelationshipDescriptor!{
        didSet{
            iconLabel.stringValue = relationship.toMany ? "M" : "O"
            nameLabel.stringValue = relationship.name
        }
    }
    
    @IBOutlet weak var iconLabel: NSTextField!
    @IBOutlet weak var nameLabel: NSTextField!{
        didSet{
            editableLabel = nameLabel
        }
    }
    
    override func nameDidChange(_ newName: String)
    {
        super.nameDidChange(newName)
        delegate?.relationshipNameDidChange(relationship, newName: newName)
    }
}
