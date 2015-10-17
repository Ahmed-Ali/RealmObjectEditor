//
//  ColorableView.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Cocoa

@IBDesignable
class ColorableView: NSView {

    @IBInspectable
    var backgroundColor: NSColor = NSColor.whiteColor(){
    didSet{
        needsDisplay = true
    }
    }
    
    @IBInspectable
    var topSeperatorWidth: CGFloat = 0{
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var topSeperatorColor: NSColor = NSColor.whiteColor(){
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var leftSeperatorWidth: CGFloat = 0{
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var leftSeperatorColor: NSColor = NSColor.whiteColor(){
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var bottomSeperatorWidth: CGFloat = 0{
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var bottomSeperatorColor: NSColor = NSColor.whiteColor(){
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var rightSeperatorWidth: CGFloat = 0{
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var rightSeperatorColor: NSColor = NSColor.whiteColor(){
        didSet{
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var cornerRadius : CGFloat = 0{
        didSet{
            wantsLayer = true
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var borderWidth : CGFloat = 0{
        didSet{
            wantsLayer = true
            needsDisplay = true
        }
    }
    
    @IBInspectable
    var borderColor : NSColor = NSColor.clearColor(){
        didSet{
            wantsLayer = true
            needsDisplay = true
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        backgroundColor.setFill()
        NSRectFill(self.bounds)
        if topSeperatorWidth > 0{
            drawTopSep(dirtyRect)
        }
        
        if leftSeperatorWidth > 0{
            drawLeftSep(dirtyRect)
        }
        
        if bottomSeperatorWidth > 0{
            drawBottomSep(dirtyRect)
        }
        
        if rightSeperatorWidth > 0{
            drawRightSep(dirtyRect)
        }
        layer?.edgeAntialiasingMask = [.LayerBottomEdge, .LayerTopEdge, .LayerLeftEdge, .LayerRightEdge]
        layer?.borderColor = borderColor.CGColor
        layer?.cornerRadius = cornerRadius
        layer?.borderWidth = borderWidth
    }
    
    
    func drawTopSep(rect: NSRect)
    {
        topSeperatorColor.setFill()
        let y = rect.origin.y + rect.size.height - topSeperatorWidth
        NSRectFill(NSMakeRect(rect.origin.x, y, rect.size.width, topSeperatorWidth))
    }
    
    func drawLeftSep(rect: NSRect)
    {
        leftSeperatorColor.setFill()
       
        NSRectFill(NSMakeRect(rect.origin.x, rect.origin.y, leftSeperatorWidth, rect.size.height))
    }
    
    func drawBottomSep(rect: NSRect)
    {
        bottomSeperatorColor.setFill()
        
        NSRectFill(NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, bottomSeperatorWidth))
    }
    
    func drawRightSep(rect: NSRect)
    {
        rightSeperatorColor.setFill()
        let x = rect.origin.x + rect.size.width - rightSeperatorWidth
        NSRectFill(NSMakeRect(x, rect.origin.y, rightSeperatorWidth, rect.size.height))
    }
}
