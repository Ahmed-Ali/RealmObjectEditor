//
//  RelationshipDestinationCell.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/17/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa
protocol RelationshipDestinationCellDelegate : class{
    func relationshipDestinationDidChange(cell: RelationshipDestinationCell, relationship: RelationshipDescriptor)
}

class RelationshipDestinationCell: NSTableCellView {

    @IBOutlet weak var destinationPopUpButton: NSPopUpButton!

    weak var delegate : RelationshipDestinationCellDelegate!
    var allEntities : [EntityDescriptor]!{
        didSet{
            destinationPopUpButton.removeAllItems()
            destinationPopUpButton.addItemWithTitle("No Value")
            destinationPopUpButton.addItemsWithTitles(allEntities.map{
                (entity) -> String in
                entity.name
                })
        }
    }
    var relationship: RelationshipDescriptor!{
        didSet{
            if relationship.destinationName != nil{
                destinationPopUpButton.selectItemWithTitle(relationship.destinationName)
            }else{
                destinationPopUpButton.selectItemAtIndex(0)
            }
            
        }
    }
    
    
    
    
    @IBAction func changeRelationDestination(sender: AnyObject)
    {
        relationship.destinationName = destinationPopUpButton.titleOfSelectedItem
        delegate?.relationshipDestinationDidChange(self, relationship: relationship)
    }
}
