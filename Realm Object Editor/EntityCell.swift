//
//  EntityCellView.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Cocoa

protocol EntityNameCellDelegate : class{
    func entityNameDidChange(_ entity: EntityDescriptor!, newName: String)
}

class EntityCell: ClickableCell{
    
    @IBOutlet var entityNameLabel: NSTextField!{
        didSet{
            editableLabel = entityNameLabel
        }
    }
    
    weak var delegate : EntityNameCellDelegate!
    var entity: EntityDescriptor!{
        didSet{
            entityNameLabel.stringValue = entity.name
        }
    }
    
    override func nameDidChange(_ newName: String)
    {
        super.nameDidChange(newName)
        delegate?.entityNameDidChange(entity, newName: newName)
    }
    
    
}

