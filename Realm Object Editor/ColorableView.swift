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
    var backgroundColor: NSColor = NSColor.white{
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
    var topSeperatorColor: NSColor = NSColor.white{
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
    var leftSeperatorColor: NSColor = NSColor.white{
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
    var bottomSeperatorColor: NSColor = NSColor.white{
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
    var rightSeperatorColor: NSColor = NSColor.white{
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
    var borderColor : NSColor = NSColor.clear{
        didSet{
            wantsLayer = true
            needsDisplay = true
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor.setFill()
        self.bounds.fill()
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
        layer?.edgeAntialiasingMask = [.layerBottomEdge, .layerTopEdge, .layerLeftEdge, .layerRightEdge]
        layer?.borderColor = borderColor.cgColor
        layer?.cornerRadius = cornerRadius
        layer?.borderWidth = borderWidth
    }
    
    
    func drawTopSep(_ rect: NSRect)
    {
        topSeperatorColor.setFill()
        let y = rect.origin.y + rect.size.height - topSeperatorWidth
        NSMakeRect(rect.origin.x, y, rect.size.width, topSeperatorWidth).fill()
    }
    
    func drawLeftSep(_ rect: NSRect)
    {
        leftSeperatorColor.setFill()
       
        NSMakeRect(rect.origin.x, rect.origin.y, leftSeperatorWidth, rect.size.height).fill()
    }
    
    func drawBottomSep(_ rect: NSRect)
    {
        bottomSeperatorColor.setFill()
        
        NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, bottomSeperatorWidth).fill()
    }
    
    func drawRightSep(_ rect: NSRect)
    {
        rightSeperatorColor.setFill()
        let x = rect.origin.x + rect.size.width - rightSeperatorWidth
        NSMakeRect(x, rect.origin.y, rightSeperatorWidth, rect.size.height).fill()
    }
}
