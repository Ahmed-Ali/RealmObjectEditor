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
    func tableView(_ tableView: ClickableTableView, didClickOnRow row: Int)
}

class ClickableTableView: NSTableView {
    
    weak var extendedDelegate : ExtendedTableViewDelegate!
    fileprivate var prevSelectedRow = -1
    override func mouseDown(with theEvent: NSEvent) {
        
        let globalLocation = theEvent.locationInWindow
        let localLocation = convert(globalLocation, from: nil)
        let clickedRow = row(at: localLocation)
//        super.mouseDown(theEvent)
        prevSelectedRow = selectedRow
        if clickedRow > -1{
            selectRowIndexes(IndexSet(integer: clickedRow), byExtendingSelection: false)
            extendedDelegate?.tableView(self, didClickOnRow: clickedRow)
        }
        
        
    }
    

    override func keyDown(with theEvent: NSEvent) {
        //36 enter button is down
        //53 is the esc button
        if selectedRow > -1{
            if let cell = view(atColumn: 0, row: selectedRow, makeIfNecessary: false) as? ClickableCell{
                if theEvent.keyCode == 36{
                    cell.beginEditing()
                }else if theEvent.keyCode == 53{
                    cell.endEditing()
                }
            }
        }
        
    }
    override func mouseUp(with theEvent: NSEvent) {
        let globalLocation = theEvent.locationInWindow
        let localLocation = convert(globalLocation, from: nil)
        let clickedRow = row(at: localLocation)
        
        if clickedRow == prevSelectedRow && clickedRow > -1{
            if let cell = view(atColumn: 0, row: clickedRow, makeIfNecessary: false) as? ClickableCell{
                //forward the touch event...
                cell.mouseUp(with: theEvent)
            }
        }else{
            //ask previous cell to stop editing
            if prevSelectedRow > -1{
                if let cell = view(atColumn: 0, row: prevSelectedRow, makeIfNecessary: false) as? ClickableCell{
                    cell.endEditing()
                }
                prevSelectedRow = clickedRow
            }
            
        }
        
        super.mouseUp(with: theEvent)
    }
}
