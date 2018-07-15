//
//  RelationshipDestinationCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/17/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa
protocol RelationshipDestinationCellDelegate : class{
    func relationshipDestinationDidChange(_ cell: RelationshipDestinationCell, relationship: RelationshipDescriptor)
}

class RelationshipDestinationCell: NSTableCellView {

    @IBOutlet weak var destinationPopUpButton: NSPopUpButton!

    weak var delegate : RelationshipDestinationCellDelegate!
    var allEntities : [EntityDescriptor]!{
        didSet{
            destinationPopUpButton.removeAllItems()
            destinationPopUpButton.addItem(withTitle: "No Value")
            destinationPopUpButton.addItems(withTitles: allEntities.map{
                (entity) -> String in
                entity.name
                })
        }
    }
    var relationship: RelationshipDescriptor!{
        didSet{
            if relationship.destinationName != nil{
                destinationPopUpButton.selectItem(withTitle: relationship.destinationName)
            }else{
                destinationPopUpButton.selectItem(at: 0)
            }
            
        }
    }
    
    
    
    
    @IBAction func changeRelationDestination(_ sender: AnyObject)
    {
        relationship.destinationName = destinationPopUpButton.titleOfSelectedItem
        delegate?.relationshipDestinationDidChange(self, relationship: relationship)
    }
}
