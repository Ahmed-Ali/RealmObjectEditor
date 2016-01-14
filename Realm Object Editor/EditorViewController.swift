//
//  ViewController.swift
//  Realm Object Editor
//
//  Created by Ahmed Ali on 12/26/14.
//  Copyright (c) 2014 Ahmed Ali. All rights reserved.
//

import Cocoa



class EditorViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, ExtendedTableViewDelegate ,NSTextFieldDelegate, AttributeTypeCellDelegate, RelationshipDestinationCellDelegate, EntityNameCellDelegate, AttributeNameCellDelegate, RelationshipNameCellDelegate, NSUserNotificationCenterDelegate {

    @IBOutlet weak var entitiesTable: ClickableTableView!
    
    @IBOutlet weak var attributesTable: ClickableTableView!
    
    @IBOutlet weak var relationshipsTable: ClickableTableView!
    
    
    //MARK- Option containers
    @IBOutlet weak var entityOptionsContainer: ColorableView!
    @IBOutlet weak var attributeOptionsContainer: ColorableView!
    @IBOutlet weak var noSelectionContainer: ColorableView!
    @IBOutlet weak var relationshipOptionsContainer: ColorableView!
    var optionContainers : [ColorableView]!{
        return [entityOptionsContainer, attributeOptionsContainer, noSelectionContainer, relationshipOptionsContainer]
    }
    
    //MARK: - Autolayout Constraints
    @IBOutlet weak var attributesListHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var relationsListHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Entity, Attribute and Relatioship containers
    @IBOutlet weak var entityContentAsListContainer: ColorableView!
    @IBOutlet weak var attributesListContainer: ColorableView!
    @IBOutlet weak var relationsListContainer: ColorableView!
    
    
    
    
    //MARK: - Selected Attribute
    @IBOutlet weak var attributeNameField: NSTextField!
    @IBOutlet weak var attributeIgnoredCheckbox: NSButton!
    @IBOutlet weak var attributePrimaryKeyCheckbox: NSButton!
    @IBOutlet weak var attributeIndexedCheckbox: NSButton!
    @IBOutlet weak var attributeDefaultCheckbox: NSButton!
    @IBOutlet weak var attributeDefaultValueField: NSTextField!
    @IBOutlet weak var attributeTypesPopup: NSPopUpButton!
    var selectedAttribute : AttributeDescriptor!{
        didSet{
            selectedAttributeDidChange()
        }
    }
    
    //MARK: - Selected Relationship
    var selectedRelationship : RelationshipDescriptor!{
        didSet{
            selectedRelationshipDidChange()
        }
    }
    
    @IBOutlet weak var relationshipNameField: NSTextField!
    @IBOutlet weak var relationshipDestinationPopup: NSPopUpButton!
    @IBOutlet weak var relationshipToManyCheckbox: NSButton!
    
    //MARK: - Selected Entity
    @IBOutlet weak var entityNameField: NSTextField!

    @IBOutlet weak var entityParentClassField: NSTextField!
    
    var selectedEntity : EntityDescriptor!{
        didSet{
            selectedEntityDidChange()
        }
    }
    
    var entities : [EntityDescriptor] = [EntityDescriptor](){
        didSet{
            entitiesTable.reloadData()
        }
    }

    //MARK: - Misc
    let contentListHeight = CGFloat(200)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noSelectionContainer.hidden = false
        entitiesTable.extendedDelegate = self
        attributesTable.extendedDelegate = self
        relationshipsTable.extendedDelegate = self
        attributeTypesPopup.removeAllItems()
        attributeTypesPopup.addItemsWithTitles(supportedTypesAsStringsArray())
        
    }
    
    
    
    //MARK: - Entities
    func selectedEntityDidChange()
    {
        for view in optionContainers {
            view.hidden = true
        }
        
        attributesTable.reloadData()
        relationshipsTable.reloadData()
        selectedAttribute = nil
        if selectedEntity == nil{
            noSelectionContainer.hidden = false
            return
        }
        
        entityNameField.stringValue = selectedEntity.name
        entityParentClassField.stringValue = selectedEntity.superClassName
        entityOptionsContainer.hidden = false
        
    }
    
    
    @IBAction func entityParentClassNameDidChange(sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        selectedEntity.superClassName = entityParentClassField.stringValue
    }
    
    @IBAction func selectedEntityNameDidChange(sender: AnyObject)
    {
        entityNameDidChange(selectedEntity, newName: entityNameField.stringValue)
        
    }
    
    func entityNameAlreadyUsed(entityName : String) -> Bool
    {
        for entity in entities{
            if entity.name == entityName{
                return true
            }
            
        }
        
        return false

    }
    
    
    //MARK: - EntityNameCellDelegate
    func entityNameDidChange(entity: EntityDescriptor!, newName: String)
    {
        if entity == nil{
            return
        }
        if newName.characters.count == 0{
            entityNameField.stringValue = entity.name
            showErrorMessage(NSLocalizedString("EMPTY_ENTITY_NAME", tableName: "ErrorMessages", value:"Entity name cannot be empty", comment: "Displayed when trying to remove entity name"))
            
            return
        }
        if newName == entity.name{
            return
        }
        if entityNameAlreadyUsed(newName){
            showErrorMessage(NSLocalizedString("ENTITY_NAME_ALREADY_IN_USE", tableName: "ErrorMessages", value:"You can not have two entities with the same name", comment:"Displayed when renaming an entity to already used name"))
            
            
            entityNameField.stringValue = entity.name
            
            
            return
        }
        
        
        entity.name = newName
        entityNameField.stringValue = newName
       
        let row = entitiesTable.selectedRow
        if row > -1{
            let indexSet = NSIndexSet(index: row)
            entitiesTable.reloadDataForRowIndexes(indexSet, columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, 1)))
            entitiesTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    
    //MARK: - Relationships
    func selectedRelationshipDidChange()
    {
        if selectedRelationship != nil{
            for view in optionContainers {
                view.hidden = true
            }
            
            relationshipOptionsContainer.hidden = false
            //Fill option with the selected relationship data
            populateRelationshipUI()
        }
    }
    
    @IBAction func selectedRelationshipNameDidChange(sender: AnyObject)
    {
        let newName = relationshipNameField.stringValue
        relationshipNameDidChange(selectedRelationship, newName: newName)
    }
    
    
    @IBAction func selectedRelationshipDestinationDidChange(sender: AnyObject)
    {
        if selectedRelationship == nil{
            return
        }
        selectedRelationship.destinationName = relationshipDestinationPopup.titleOfSelectedItem
        
        
        populateRelationshipUI()
    }
    
    
    @IBAction func selectedRelationshipToManyStateDidChange(sender: AnyObject)
    {
        if selectedRelationship == nil{
            return
        }
        selectedRelationship.toMany = relationshipToManyCheckbox.state == NSOnState
        populateRelationshipUI()
        
    }
    
    func populateRelationshipUI()
    {
        if selectedRelationship == nil{
            return
        }
        relationshipDestinationPopup.removeAllItems()
        relationshipDestinationPopup.addItemWithTitle("No Value")
        relationshipDestinationPopup.addItemsWithTitles(entities.map({ (e) -> String in
            e.name
        }))
        
        if selectedRelationship == nil{
            return
        }
        relationshipToManyCheckbox.state = selectedRelationship.toMany ? NSOnState : NSOffState
        relationshipNameField.stringValue = selectedRelationship.name
        if selectedRelationship.destinationName != nil{
            relationshipDestinationPopup.selectItemWithTitle(selectedRelationship.destinationName)
        }else{
            relationshipDestinationPopup.selectItemAtIndex(0)
        }
        
        let row = relationshipsTable.selectedRow
        if row > -1{
            let indexSet = NSIndexSet(index: row)
            relationshipsTable.reloadDataForRowIndexes(indexSet, columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, 2)))
            relationshipsTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    
    func relationshipNameAlreadyUsed(name: String) -> Bool
    {
        if selectedEntity == nil{
            return false
        }
        
        for r in selectedEntity.relationships{
            if r.name == name{
                return true
            }
            
        }
        
        return false
    }
    
    //MARK: - RelationshipNameCellDelegate
    func relationshipNameDidChange(relationship: RelationshipDescriptor!, newName: String)
    {
        if relationship != nil{
            
            if newName == relationship.name{
                return
            }
            if relationshipNameAlreadyUsed(newName){
                showErrorMessage(NSLocalizedString("RELATIONSHIP_NAME_ALREADY_IN_USE", tableName: "ErrorMessages", value: "The relationship name is already used for another relationship", comment: "Displayed when the user changes a relationship name with a name that is already in use"))
                
                return
            }
            
            relationship.name = newName
            populateRelationshipUI()
        }
    }
    
    
    //MARK: - Attributes
    func selectedAttributeDidChange()
    {
        for view in optionContainers {
            view.hidden = true
        }
        
        if selectedAttribute != nil{
            attributeOptionsContainer.hidden = false
            //Fill option with the selected attribute data
            populateAttributeUI()
            
        }
    }
    
    func populateAttributeUI()
    {
        if selectedAttribute == nil{
            return
        }
        attributeNameField.stringValue = selectedAttribute.name
        attributeIgnoredCheckbox.state = selectedAttribute.ignored ? NSOnState : NSOffState
        attributePrimaryKeyCheckbox.state = selectedAttribute.isPrimaryKey ? NSOnState : NSOffState
        attributeIndexedCheckbox.state = selectedAttribute.indexed ? NSOnState : NSOffState
        attributeDefaultCheckbox.state = selectedAttribute.hasDefault ? NSOnState : NSOffState
        if "\(selectedAttribute.type.defaultValue)" == "\(NoDefaultValue)"{
            attributeDefaultValueField.enabled = false
            attributeDefaultValueField.stringValue = ""
            attributeDefaultCheckbox.state = NSOffState
            attributeDefaultCheckbox.enabled = false
        }else{
            attributeDefaultValueField.stringValue = selectedAttribute.hasDefault ? "\(selectedAttribute.defaultValue)" : ""
            attributeDefaultValueField.enabled = true
            attributeDefaultCheckbox.enabled = true
        }
        
        attributeTypesPopup.selectItemWithTitle(selectedAttribute.type.typeName)
        
        
    }
    func reloadAndReselectAttribute()
    {
        let row = attributesTable.selectedRow
        if row > -1{
            let indexSet = NSIndexSet(index: row)
            attributesTable.reloadDataForRowIndexes(indexSet, columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, 2)))
            attributesTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    @IBAction func attributeNameDidChange(sender: AnyObject)
    {
        attributeNameDidChange(selectedAttribute, newName: attributeNameField.stringValue)
    }
    
    func attributeNameAlreadyUsed(attrName: String) -> Bool
    {
        if selectedEntity == nil{
            return false
        }
        for attr in selectedEntity.attributes{
            if attr.name == attrName{
                return true
            }
            
        }
        return false
        
    }
    
    @IBAction func attributeIgnoredStateDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if (selectedAttribute.isPrimaryKey || selectedAttribute.indexed) && attributeIgnoredCheckbox.state == NSOnState{
            attributeIgnoredCheckbox.state = NSOffState
            showErrorMessage(NSLocalizedString("PRIMARYKEY_AND_INDEX_CAN_NOT_BE_IGNORED", tableName: "ErrorMessages", value:"Primary key and indexed attributes can not be marked as ignored", comment: "Displayed when attempting to set a primary key or an indexed attribute as ignored"))
            
           
            return
        }
        selectedAttribute.ignored = attributeIgnoredCheckbox.state == NSOnState
        
    }
    
    @IBAction func attributePrimaryKeyStateDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if attributePrimaryKeyCheckbox.state == NSOffState{
            selectedAttribute.isPrimaryKey = false
            return
        }
        
        if !selectedAttribute.type.canBePrimaryKey{
            let errorMessage = String(format:NSLocalizedString("TRYING_TO_SET_PRIMARY_KEY_FOR_INVALID_ATTR_TYPE", tableName: "ErrorMessages", value:"This attribute type (%@) can not be used as a primary key", comment:"Displayed when trying a primary key for attribute with type that can not be a used with primary keys."), selectedAttribute.type.typeName)
            
            
            
            showErrorMessage(errorMessage)
            
            attributePrimaryKeyCheckbox.state = NSOffState
        }
        //otherwise make sure we can only have one primary key
        for attribute in selectedEntity.attributes{
            if attribute.isPrimaryKey{
                attributePrimaryKeyCheckbox.state = NSOffState
                let errorMessage = String(format:NSLocalizedString("TRYING_TO_SET_MULTI_PRIMARY_KEYS", tableName: "ErrorMessages", value:"You already set %@ as the primary key for this entity. You can have only one primary key per entity", comment:"Displayed when trying to set more than one primary key for the same entity."), attribute.name)
                
                
                
                showErrorMessage(errorMessage)
                return
            }
        }
        
        selectedAttribute.isPrimaryKey = true
        if selectedAttribute.ignored{
            selectedAttribute.ignored = false
            attributeIgnoredCheckbox.state = NSOffState
        }
    }
    
    
    @IBAction func attributeIndexedStateDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if selectedAttribute.ignored && attributeIndexedCheckbox.state == NSOnState{
            attributeIndexedCheckbox.state = NSOffState
            showErrorMessage(NSLocalizedString("IGNORE_INDEXED_ATTR", tableName: "ErrorMessages", value:"Ignored attributes can not be indexed.", comment:"Displayed when user attempt to set ignored attribute as an indexed attribute"))
            
           
            return
        }
        selectedAttribute.indexed = attributeIndexedCheckbox.state == NSOnState
    }
    
    
    @IBAction func attributeDefaultValueDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        selectedAttribute.hasDefault = true
        attributeDefaultCheckbox.state = NSOnState
        selectedAttribute.defaultValue = attributeDefaultValueField.stringValue
        
    }
    
    
    @IBAction func attributeHasDefaultStateDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        
        selectedAttribute.hasDefault = attributeDefaultCheckbox.state == NSOnState
        if !selectedAttribute.hasDefault{
            attributeDefaultValueField.stringValue = ""
        }else{
            attributeDefaultValueField.stringValue = "\(selectedAttribute.type.defaultValue)"
        }
    }
    
    @IBAction func attributeTypeDidChange(sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        selectedAttribute.type = arrayOfSupportedTypes[attributeTypesPopup.indexOfSelectedItem]
        reloadAndReselectAttribute()
    }
    
    //MARK: - AttributeNameCellDelegate
    func attributeNameDidChange(attribute: AttributeDescriptor!, newName: String)
    {
        if attribute == nil{
            return
        }

        if newName.characters.count == 0{
            showErrorMessage(NSLocalizedString("EMPTY_ATTR_NAME", tableName: "ErrorMessages", value:"Attribute name can not be empty", comment:"Displayed when user tries to remove an attribute name"))
            
            return
        }
        if newName == attribute.name{
            return
        }
        if attributeNameAlreadyUsed(newName){
            showErrorMessage(NSLocalizedString("ATTR_NAME_ALREADY_IN_USE", tableName: "ErrorMessages", value:"This attribute name is already used for another attribute", comment:"Displayed when user changes an attribute name to an already used attribute name"))
            
            
            
            attributeNameField.stringValue = attribute.name
            attributesTable.reloadData()
            return
        }
        attribute.name = newName
        attributeNameField.stringValue = newName
        reloadAndReselectAttribute()
    }
    
    //MARK: - Actions
    @IBAction func addEntity(sender: AnyObject)
    {
        var entityName = "Entity"
        if entities.count > 0{
            for i in 0 ..< entities.count{
                let tmpName = "\(entityName)\(i+1)"
                
                if !entityNameAlreadyUsed(tmpName){
                    entityName = tmpName
                    break
                }
            }
        }
        let entity = EntityDescriptor(name:entityName)
        entities.append(entity)
        entitiesTable.reloadData()
        relationshipsTable.reloadData()
    }
    
    
    @IBAction func removeSelectedEntity(sender: AnyObject)
    {
        let row = entitiesTable.selectedRow
        if row < 0{
            //nothing selected
            return
        }
        selectedEntity = nil
        let removedEntityName = entities.removeAtIndex(row).name
        entitiesTable.reloadData()
        //remove any related relations
        for entity in entities{
            let relationships = entity.relationships
            for i in 0 ..< relationships.count{
                let relationship = relationships[i]
                if relationship.destinationName == removedEntityName{
                    entity.relationships.removeAtIndex(i)
                }
            }
        }
        relationshipsTable.reloadData()
    }
    
    
    @IBAction func addAttribute(sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        var attrName = "attribute"
        if selectedEntity.attributes.count > 0{
            for i in 0 ..< selectedEntity.attributes.count{
                let tmpName = "\(attrName)\(i+1)"
                
                if !attributeNameAlreadyUsed(tmpName){
                    attrName = tmpName
                    break
                }
            }
            
        }
        let attribute = AttributeDescriptor(name: attrName)
        
        selectedEntity.attributes.append(attribute)
        attributesTable.reloadData()
    }
    
    
    @IBAction func removeSelectedAttribute(sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        let row = attributesTable.selectedRow
        if row < 0{
            return
        }
        selectedAttribute = nil
        selectedEntity.attributes.removeAtIndex(row)
        attributesTable.reloadData()
    }
    
    
    @IBAction func addRelationship(sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        var relationshipName = "relationship"
        if selectedEntity.relationships.count > 0{
            for i in 0 ..< selectedEntity.relationships.count{
                let tmpName = "\(relationshipName)\(i+1)"
                
                if !relationshipNameAlreadyUsed(tmpName){
                    relationshipName = tmpName
                    break
                }
            }
        }
        let relationship = RelationshipDescriptor(name:relationshipName)
        selectedEntity.relationships.append(relationship)
        relationshipsTable.reloadData()
    }
    
    
    @IBAction func removeSelectedRelationship(sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        let row = relationshipsTable.selectedRow
        if row < 0{
            return
        }
        selectedEntity.relationships.removeAtIndex(row)
        relationshipsTable.reloadData()
    }
    
    @IBAction func toggleRelationsListContainer(sender: NSButton)
    {
        let animator = relationsListHeightConstraint.animator()
        if animator.constant == relationsListContainer.bottomSeperatorWidth{
            //show it
            animator.constant = contentListHeight
            sender.title = "▼ Relations"
        }else{
            //hide it
            animator.constant = relationsListContainer.bottomSeperatorWidth
            sender.title = "► Relations"
        }
    }
    
    
    //MARK: - Show/hide contents
    @IBAction func toggleAttributesListContainer(sender: NSButton)
    {
        let animator = attributesListHeightConstraint.animator()
        
        if animator.constant == attributesListContainer.bottomSeperatorWidth{
            //show it
            animator.constant = contentListHeight
            sender.title = "▼ Attributes"
        }else{
            //hide it
            animator.constant = attributesListContainer.bottomSeperatorWidth
            sender.title = "► Attributes"
        }
    }
    
    //MARK: - Entity cells handling
    func entityCellAtRow(row: Int) -> NSView
    {
        let cell = entitiesTable.makeViewWithIdentifier("entityCell", owner: self) as! EntityCell
        cell.entity = entities[row]
        cell.delegate = self
        return cell
    }
    
    //MARK: - Attribute cells handling
    func cellForAttributeAtRow(row: Int, column: NSTableColumn?) -> NSView
    {
        let attribute = selectedEntity.attributes[row]
        if column?.identifier == "name"{
            let cell = attributesTable.makeViewWithIdentifier("name", owner: self) as! AttributeNameCell
            cell.attribute = attribute
            cell.delegate = self
            return cell
        }else{
            let cell = attributesTable.makeViewWithIdentifier("type", owner: self) as! AttributeTypeCell
            cell.attribute = attribute
            cell.delegate = self
            return cell
        }
    }
    //MARK: - AttributeTypeCellDelegate
    func attributeTypeDidChange(attribute attribute: AttributeDescriptor)
    {
        attributesTable.reloadData()
        populateAttributeUI()
    }
    
    
    
    //MARK: - Relationship cells handling
    func cellForRelationshipAtRow(row: Int, column: NSTableColumn?) -> NSView
    {
        let relationship = selectedEntity.relationships[row]
        if column?.identifier == "name"{
            let cell = relationshipsTable.makeViewWithIdentifier("name", owner: self) as! RelationshipNameCell
            cell.relationship = relationship
            cell.delegate = self
            return cell
        }else{
            let cell = relationshipsTable.makeViewWithIdentifier("destination", owner: self) as! RelationshipDestinationCell
            cell.allEntities = entities
            cell.relationship = relationship
            cell.delegate = self
            return cell
        }
    }
    
    //MARK: - RelationshipDestinationCellDelegate
    func relationshipDestinationDidChange(cell: RelationshipDestinationCell, relationship: RelationshipDescriptor)
    {
        relationshipsTable.reloadData()
        populateRelationshipUI()
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRowsInTableView(tableView: NSTableView) -> Int
    {
        if tableView == entitiesTable{
            return entities.count
        }else{
            if selectedEntity != nil{
                if tableView == attributesTable{
                    return selectedEntity.attributes.count
                }else{
                    return selectedEntity.relationships.count
                }
            }
        }
        
        return 0
    }
    
    
    //MARK: - NSTableViewDelegate
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if tableView == entitiesTable{
            return entityCellAtRow(row)
        }else if tableView == attributesTable{
            return cellForAttributeAtRow(row, column: tableColumn)
        }else{
            return cellForRelationshipAtRow(row, column: tableColumn)
        }
       
    }
    
    
    
    
    
    func tableView(tableView: NSTableView, nextTypeSelectMatchFromRow startRow: Int, toRow endRow: Int, forString searchString: String) -> Int
    {
        if tableView != entitiesTable{
            return -1
        }
        for i in startRow ..< entities.count{
            let entity = entities[i]
            if entity.name.lowercaseString.hasPrefix(searchString){
                selectedEntity = entity
                
                return i
            }
            
        }
        
        return -1
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        if tableView == entitiesTable{
            selectedEntity = entities[row]
        }else if tableView == attributesTable{
            selectedAttribute = selectedEntity.attributes[row]
        }else if tableView == relationshipsTable{
            selectedRelationship = selectedEntity.relationships[row]
        }
        return true
    }
    
    //MARK: - ExtendedTableViewDelegate
    func tableView(tableView: ClickableTableView, didClickOnRow row: Int)
    {
        if tableView == entitiesTable{
            selectedEntity = entities[row]
        }else if tableView == attributesTable{
            selectedAttribute = selectedEntity.attributes[row]
        }else if tableView == relationshipsTable{
            selectedRelationship = selectedEntity.relationships[row]
        }
    }
    
    
    //MARK: - Messages
    func showError(error: NSError)
    {
        NSAlert(error: error).runModal()
    }
    func showErrorMessage(message: String)
    {
        let alert = NSAlert()
        
        alert.messageText = message
        alert.runModal()
    }
    
    //MARK: - Validation
    func validEntities() -> Bool
    {
        for entity in entities{
            //validate attribute types
            for attr in entity.attributes{
                if attr.type is InvalidType{
                    //Invalid, a type must be selected
                    let errorMessage = String(format:NSLocalizedString("EXPORTING_INVLID_ENTITY_ATTRIBUTES", tableName: "ErrorMessages", value:"You must select a type for the %@->%@ attribute", comment:"Displayed when trying to export the entities while having invalid attribute type"), entity.name, attr.name)
                    
                    showErrorMessage(errorMessage)
                    return false;
                }
                
            }
            
            //validate the relationship destinations
            for relationship in entity.relationships{
                if relationship.destinationName == nil || relationship.destinationName == "No Value"{
                    //Invalid, a relationship must have destination
                    let errorMessage = String(format:NSLocalizedString("EXPORTING_INVLID_ENTITY_RELATIONSHIPS", tableName: "ErrorMessages", value:"You must select a destination for the %@->%@ relationship", comment:"Displayed when trying to export the entities while having a relationship without a destination"), entity.name, relationship.name)
                    
                    showErrorMessage(errorMessage)
                    return false;
                }
            }
            
        }
        
        
        return true
    }
    
    //MARK: - Export
    func exportToSwift(sender: AnyObject!)
    {
        tryToExportWithLangName("Swift")
    }
    
    func exportToObjectiveC(sender: AnyObject!)
    {
        tryToExportWithLangName("ObjC")
    }
    
    func exportToAndroidJava(sender: AnyObject!)
    {
        tryToExportWithLangName("Java")
    }
    
    func exportToAndroidKotlin(sender: AnyObject!)
    {
        tryToExportWithLangName("Kotlin")
    }
    
    func tryToExportWithLangName(langName: String)
    {
        if validEntities(){
            let lang = langWithName(langName)
            let files = EntityFilesGenerator.instance.entitiesToFiles(entities, lang: lang)
            choosePathAndSaveFiles(files)
        }
    }
    
    func langWithName(langName: String) -> LangModel
    {
        //        let fileName = "\(langName).json"
        let filePathUrl = NSBundle.mainBundle().URLForResource(langName, withExtension: "json")!
        let data = NSData(contentsOfURL: filePathUrl)
        let jsonObject = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
        let lang = LangModel(fromDictionary: jsonObject)
        return lang
    }
    
    
    //MARK: - Showing the open panel and save files
    func choosePathAndSaveFiles(files: [FileModel])
        {
            let openPanel = NSOpenPanel()
            openPanel.allowsOtherFileTypes = false
            openPanel.treatsFilePackagesAsDirectories = false
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.canCreateDirectories = true
            openPanel.prompt = "Choose"
            openPanel.beginSheetModalForWindow(view.window!, completionHandler: { (button : Int) -> Void in
                if button == NSFileHandlingPanelOKButton{
    
                    self.saveFiles(files, toPath:openPanel.URL!.path!)
    
                    
                }
            })
        }
    
    
    /**
    Saves all the generated files in the specified path
    
    - parameter path: in which to save the files
    */
    func saveFiles(files:[FileModel], toPath path: String)
    {
        var error : NSError?
        
        for file in files{
            
            let filePath = "\(path)/\(file.fileName).\(file.fileExtension)"
            
            do {
                try file.fileContent.writeToFile(filePath, atomically: false, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
            }
            if error != nil{
                showError(error!)
                break
            }
            
        }
        
        if error == nil{
            self.showDoneSuccessfully()
        }
        
    }
    
    
    /**
    Shows the top right notification. Call it after saving the files successfully
    */
    func showDoneSuccessfully()
    {
        let notification = NSUserNotification()
        notification.title = "Success!"
        notification.informativeText = "Your Realm files have been generated successfully."
        notification.deliveryDate = NSDate()
        
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        center.delegate = self
        center.deliverNotification(notification)
    }
    
    //MARK: - NSUserNotificationCenterDelegate
    func userNotificationCenter(center: NSUserNotificationCenter,
        shouldPresentNotification notification: NSUserNotification) -> Bool
    {
        return true
    }
    
}

