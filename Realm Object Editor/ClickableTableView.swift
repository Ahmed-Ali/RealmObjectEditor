//
//  ClickableTableView.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 1/16/15.
//  Copyright (c) 2015 Ahmed Ali. All rights reserved.
//

import Cocoa

protocol ExtendedTableViewDelegate : class
{
    func tableView(tableView: ClickableTableView, didClickOnRow row: Int)
}

class ClickableTableView: NSTableView {
    
    weak var extendedDelegate : ExtendedTableViewDelegate!
    private var prevSelectedRow = -1
    override func mouseDown(theEvent: NSEvent) {
        
        let globalLocation = theEvent.locationInWindow
        let localLocation = convertPoint(globalLocation, fromView: nil)
        let clickedRow = rowAtPoint(localLocation)
//        super.mouseDown(theEvent)
        prevSelectedRow = selectedRow
        if clickedRow > -1{
            selectRowIndexes(NSIndexSet(index: clickedRow), byExtendingSelection: false)
            extendedDelegate?.tableView(self, didClickOnRow: clickedRow)
        }
        
        
    }
    

    override func keyDown(theEvent: NSEvent) {
        //36 enter button is down
        //53 is the esc button
        if selectedRow > -1{
            if let cell = viewAtColumn(0, row: selectedRow, makeIfNecessary: false) as? ClickableCell{
                if theEvent.keyCode == 36{
                    cell.beginEditing()
                }else if theEvent.keyCode == 53{
                    cell.endEditing()
                }
            }
        }
        
    }
    override func mouseUp(theEvent: NSEvent) {
        let globalLocation = theEvent.locationInWindow
        let localLocation = convertPoint(globalLocation, fromView: nil)
        let clickedRow = rowAtPoint(localLocation)
        
        if clickedRow == prevSelectedRow && clickedRow > -1{
            if let cell = viewAtColumn(0, row: clickedRow, makeIfNecessary: false) as? ClickableCell{
                //forward the touch event...
                cell.mouseUp(theEvent)
            }
        }else{
            //ask previous cell to stop editing
            if prevSelectedRow > -1{
                if let cell = viewAtColumn(0, row: prevSelectedRow, makeIfNecessary: false) as? ClickableCell{
                    cell.endEditing()
                }
                prevSelectedRow = clickedRow
            }
            
        }
        
        super.mouseUp(theEvent)
    }
}
