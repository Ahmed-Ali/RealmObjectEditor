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
        noSelectionContainer.isHidden = false
        entitiesTable.extendedDelegate = self
        attributesTable.extendedDelegate = self
        relationshipsTable.extendedDelegate = self
        attributeTypesPopup.removeAllItems()
        attributeTypesPopup.addItems(withTitles: supportedTypesAsStringsArray())
        
    }
    
    
    
    //MARK: - Entities
    func selectedEntityDidChange()
    {
        for view in optionContainers {
            view.isHidden = true
        }
        
        attributesTable.reloadData()
        relationshipsTable.reloadData()
        selectedAttribute = nil
        if selectedEntity == nil{
            noSelectionContainer.isHidden = false
            return
        }
        
        entityNameField.stringValue = selectedEntity.name
        entityParentClassField.stringValue = selectedEntity.superClassName
        entityOptionsContainer.isHidden = false
        
    }
    
    
    @IBAction func entityParentClassNameDidChange(_ sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        selectedEntity.superClassName = entityParentClassField.stringValue
    }
    
    @IBAction func selectedEntityNameDidChange(_ sender: AnyObject)
    {
        entityNameDidChange(selectedEntity, newName: entityNameField.stringValue)
        
    }
    
    func entityNameAlreadyUsed(_ entityName : String) -> Bool
    {
        for entity in entities{
            if entity.name == entityName{
                return true
            }
            
        }
        
        return false

    }
    
    
    //MARK: - EntityNameCellDelegate
    func entityNameDidChange(_ entity: EntityDescriptor!, newName: String)
    {
        if entity == nil{
            return
        }
        if newName.count == 0{
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
            let indexSet = IndexSet(integer: row)
            entitiesTable.reloadData(forRowIndexes: indexSet, columnIndexes: IndexSet(integersIn: 0...0))
            entitiesTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    
    //MARK: - Relationships
    func selectedRelationshipDidChange()
    {
        if selectedRelationship != nil{
            for view in optionContainers {
                view.isHidden = true
            }
            
            relationshipOptionsContainer.isHidden = false
            //Fill option with the selected relationship data
            populateRelationshipUI()
        }
    }
    
    @IBAction func selectedRelationshipNameDidChange(_ sender: AnyObject)
    {
        let newName = relationshipNameField.stringValue
        relationshipNameDidChange(selectedRelationship, newName: newName)
    }
    
    
    @IBAction func selectedRelationshipDestinationDidChange(_ sender: AnyObject)
    {
        if selectedRelationship == nil{
            return
        }
        selectedRelationship.destinationName = relationshipDestinationPopup.titleOfSelectedItem
        
        
        populateRelationshipUI()
    }
    
    
    @IBAction func selectedRelationshipToManyStateDidChange(_ sender: AnyObject)
    {
        if selectedRelationship == nil{
            return
        }
        selectedRelationship.toMany = relationshipToManyCheckbox.state == NSControl.StateValue.on
        populateRelationshipUI()
        
    }
    
    func populateRelationshipUI()
    {
        if selectedRelationship == nil{
            return
        }
        relationshipDestinationPopup.removeAllItems()
        relationshipDestinationPopup.addItem(withTitle: "No Value")
        relationshipDestinationPopup.addItems(withTitles: entities.map({ (e) -> String in
            e.name
        }))
        
        if selectedRelationship == nil{
            return
        }
        relationshipToManyCheckbox.state = selectedRelationship.toMany ? NSControl.StateValue.on : NSControl.StateValue.off
        relationshipNameField.stringValue = selectedRelationship.name
        if selectedRelationship.destinationName != nil{
            relationshipDestinationPopup.selectItem(withTitle: selectedRelationship.destinationName)
        }else{
            relationshipDestinationPopup.selectItem(at: 0)
        }
        
        let row = relationshipsTable.selectedRow
        if row > -1{
            let indexSet = IndexSet(integer: row)
            relationshipsTable.reloadData(forRowIndexes: indexSet, columnIndexes: IndexSet(integersIn: 0...1))
            relationshipsTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    
    func relationshipNameAlreadyUsed(_ name: String) -> Bool
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
    func relationshipNameDidChange(_ relationship: RelationshipDescriptor!, newName: String)
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
            view.isHidden = true
        }
        
        if selectedAttribute != nil{
            attributeOptionsContainer.isHidden = false
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
        attributeIgnoredCheckbox.state = selectedAttribute.ignored ? NSControl.StateValue.on : NSControl.StateValue.off
        attributePrimaryKeyCheckbox.state = selectedAttribute.isPrimaryKey ? NSControl.StateValue.on : NSControl.StateValue.off
        attributeIndexedCheckbox.state = selectedAttribute.indexed ? NSControl.StateValue.on : NSControl.StateValue.off
        attributeDefaultCheckbox.state = selectedAttribute.hasDefault ? NSControl.StateValue.on : NSControl.StateValue.off
        if "\(selectedAttribute.type.defaultValue)" == "\(NoDefaultValue)"{
            attributeDefaultValueField.isEnabled = false
            attributeDefaultValueField.stringValue = ""
            attributeDefaultCheckbox.state = NSControl.StateValue.off
            attributeDefaultCheckbox.isEnabled = false
        }else{
            attributeDefaultValueField.stringValue = selectedAttribute.hasDefault ? "\(selectedAttribute.defaultValue)" : ""
            attributeDefaultValueField.isEnabled = true
            attributeDefaultCheckbox.isEnabled = true
        }
        
        attributeTypesPopup.selectItem(withTitle: selectedAttribute.type.typeName)
        
        
    }
    func reloadAndReselectAttribute()
    {
        let row = attributesTable.selectedRow
        if row > -1{
            let indexSet = IndexSet(integer: row)
            attributesTable.reloadData(forRowIndexes: indexSet, columnIndexes: IndexSet(integersIn: 0...1))
            attributesTable.selectRowIndexes(indexSet, byExtendingSelection: false)
        }
    }
    @IBAction func attributeNameDidChange(_ sender: AnyObject)
    {
        attributeNameDidChange(selectedAttribute, newName: attributeNameField.stringValue)
    }
    
    func attributeNameAlreadyUsed(_ attrName: String) -> Bool
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
    
    @IBAction func attributeIgnoredStateDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if (selectedAttribute.isPrimaryKey || selectedAttribute.indexed) && attributeIgnoredCheckbox.state == NSControl.StateValue.on{
            attributeIgnoredCheckbox.state = NSControl.StateValue.off
            showErrorMessage(NSLocalizedString("PRIMARYKEY_AND_INDEX_CAN_NOT_BE_IGNORED", tableName: "ErrorMessages", value:"Primary key and indexed attributes can not be marked as ignored", comment: "Displayed when attempting to set a primary key or an indexed attribute as ignored"))
            
           
            return
        }
        selectedAttribute.ignored = attributeIgnoredCheckbox.state == NSControl.StateValue.on
        
    }
    
    @IBAction func attributePrimaryKeyStateDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if attributePrimaryKeyCheckbox.state == NSControl.StateValue.off{
            selectedAttribute.isPrimaryKey = false
            return
        }
        
        if !selectedAttribute.type.canBePrimaryKey{
            let errorMessage = String(format:NSLocalizedString("TRYING_TO_SET_PRIMARY_KEY_FOR_INVALID_ATTR_TYPE", tableName: "ErrorMessages", value:"This attribute type (%@) can not be used as a primary key", comment:"Displayed when trying a primary key for attribute with type that can not be a used with primary keys."), selectedAttribute.type.typeName)
            
            
            
            showErrorMessage(errorMessage)
            
            attributePrimaryKeyCheckbox.state = NSControl.StateValue.off
        }
        //otherwise make sure we can only have one primary key
        for attribute in selectedEntity.attributes{
            if attribute.isPrimaryKey{
                attributePrimaryKeyCheckbox.state = NSControl.StateValue.off
                let errorMessage = String(format:NSLocalizedString("TRYING_TO_SET_MULTI_PRIMARY_KEYS", tableName: "ErrorMessages", value:"You already set %@ as the primary key for this entity. You can have only one primary key per entity", comment:"Displayed when trying to set more than one primary key for the same entity."), attribute.name)
                
                
                
                showErrorMessage(errorMessage)
                return
            }
        }
        
        selectedAttribute.isPrimaryKey = true
        if selectedAttribute.ignored{
            selectedAttribute.ignored = false
            attributeIgnoredCheckbox.state = NSControl.StateValue.off
        }
    }
    
    
    @IBAction func attributeIndexedStateDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        if selectedAttribute.ignored && attributeIndexedCheckbox.state == NSControl.StateValue.on{
            attributeIndexedCheckbox.state = NSControl.StateValue.off
            showErrorMessage(NSLocalizedString("IGNORE_INDEXED_ATTR", tableName: "ErrorMessages", value:"Ignored attributes can not be indexed.", comment:"Displayed when user attempt to set ignored attribute as an indexed attribute"))
            
           
            return
        }
        selectedAttribute.indexed = attributeIndexedCheckbox.state == NSControl.StateValue.on
    }
    
    
    @IBAction func attributeDefaultValueDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        selectedAttribute.hasDefault = true
        attributeDefaultCheckbox.state = NSControl.StateValue.on
        selectedAttribute.defaultValue = attributeDefaultValueField.stringValue
        
    }
    
    
    @IBAction func attributeHasDefaultStateDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        
        selectedAttribute.hasDefault = attributeDefaultCheckbox.state == NSControl.StateValue.on
        if !selectedAttribute.hasDefault{
            attributeDefaultValueField.stringValue = ""
        }else{
            attributeDefaultValueField.stringValue = "\(selectedAttribute.type.defaultValue)"
        }
    }
    
    @IBAction func attributeTypeDidChange(_ sender: AnyObject)
    {
        if selectedAttribute == nil{
            return
        }
        selectedAttribute.type = arrayOfSupportedTypes[attributeTypesPopup.indexOfSelectedItem]
        reloadAndReselectAttribute()
    }
    
    //MARK: - AttributeNameCellDelegate
    func attributeNameDidChange(_ attribute: AttributeDescriptor!, newName: String)
    {
        if attribute == nil{
            return
        }

        if newName.count == 0{
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
    @IBAction func addEntity(_ sender: AnyObject)
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
        entitiesTable.scrollToEndOfDocument(nil)
    }
    
    
    @IBAction func removeSelectedEntity(_ sender: AnyObject)
    {
        let row = entitiesTable.selectedRow
        if row < 0{
            //nothing selected
            return
        }
        selectedEntity = nil
        let removedEntityName = entities.remove(at: row).name
        entitiesTable.reloadData()
        //remove any related relations
        for entity in entities{
            let relationships = entity.relationships
            for i in 0 ..< relationships.count{
                let relationship = relationships[i]
                if relationship.destinationName == removedEntityName{
                    entity.relationships.remove(at: i)
                }
            }
        }
        relationshipsTable.reloadData()
    }
    
    
    @IBAction func addAttribute(_ sender: AnyObject)
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
        attributesTable.scrollToEndOfDocument(nil)
    }
    
    
    @IBAction func removeSelectedAttribute(_ sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        let row = attributesTable.selectedRow
        if row < 0{
            return
        }
        selectedAttribute = nil
        selectedEntity.attributes.remove(at: row)
        attributesTable.reloadData()
    }
    
    
    @IBAction func addRelationship(_ sender: AnyObject)
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
        relationshipsTable.scrollToEndOfDocument(nil)
    }
    
    
    @IBAction func removeSelectedRelationship(_ sender: AnyObject)
    {
        if selectedEntity == nil{
            return
        }
        let row = relationshipsTable.selectedRow
        if row < 0{
            return
        }
        selectedEntity.relationships.remove(at: row)
        relationshipsTable.reloadData()
    }
    
    @IBAction func toggleRelationsListContainer(_ sender: NSButton)
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
    @IBAction func toggleAttributesListContainer(_ sender: NSButton)
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
    func entityCellAtRow(_ row: Int) -> NSView
    {
        let cell = entitiesTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "entityCell"), owner: self) as! EntityCell
        cell.entity = entities[row]
        cell.delegate = self
        return cell
    }
    
    //MARK: - Attribute cells handling
    func cellForAttributeAtRow(_ row: Int, column: NSTableColumn?) -> NSView
    {
        let attribute = selectedEntity.attributes[row]
        if (column?.identifier)!.rawValue == "name"{
            let cell = attributesTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "name"), owner: self) as! AttributeNameCell
            cell.attribute = attribute
            cell.delegate = self
            return cell
        }else{
            let cell = attributesTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "type"), owner: self) as! AttributeTypeCell
            cell.attribute = attribute
            cell.delegate = self
            return cell
        }
    }
    //MARK: - AttributeTypeCellDelegate
    func attributeTypeDidChange(attribute: AttributeDescriptor)
    {
        attributesTable.reloadData()
        populateAttributeUI()
    }
    
    
    
    //MARK: - Relationship cells handling
    func cellForRelationshipAtRow(_ row: Int, column: NSTableColumn?) -> NSView
    {
        let relationship = selectedEntity.relationships[row]
        if (column?.identifier)!.rawValue == "name"{
            let cell = relationshipsTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "name"), owner: self) as! RelationshipNameCell
            cell.relationship = relationship
            cell.delegate = self
            return cell
        }else{
            let cell = relationshipsTable.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "destination"), owner: self) as! RelationshipDestinationCell
            cell.allEntities = entities
            cell.relationship = relationship
            cell.delegate = self
            return cell
        }
    }
    
    //MARK: - RelationshipDestinationCellDelegate
    func relationshipDestinationDidChange(_ cell: RelationshipDestinationCell, relationship: RelationshipDescriptor)
    {
        relationshipsTable.reloadData()
        populateRelationshipUI()
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int
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
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if tableView == entitiesTable{
            return entityCellAtRow(row)
        }else if tableView == attributesTable{
            return cellForAttributeAtRow(row, column: tableColumn)
        }else{
            return cellForRelationshipAtRow(row, column: tableColumn)
        }
       
    }
    
    
    
    
    
    func tableView(_ tableView: NSTableView, nextTypeSelectMatchFromRow startRow: Int, toRow endRow: Int, for searchString: String) -> Int
    {
        if tableView != entitiesTable{
            return -1
        }
        for i in startRow ..< entities.count{
            let entity = entities[i]
            if entity.name.lowercased().hasPrefix(searchString){
                selectedEntity = entity
                
                return i
            }
            
        }
        
        return -1
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
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
    func tableView(_ tableView: ClickableTableView, didClickOnRow row: Int)
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
    func showError(_ error: NSError)
    {
        NSAlert(error: error).runModal()
    }
    func showErrorMessage(_ message: String)
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
    @IBAction func exportToSwift(_ sender: AnyObject!)
    {
        tryToExportWithLangName("Swift")
    }
    
    @IBAction func exportToObjectiveC(_ sender: AnyObject!)
    {
        tryToExportWithLangName("ObjC")
    }
    
    @IBAction func exportToAndroidJava(_ sender: AnyObject!)
    {
        showDialogToInputPackage(withTitle: "What is your packege name?",
                                 information: "example: com.youcompanyname.youappname.model",
                                 placeholder: "Input package name") { packageName in
                                    for entity in self.entities {
                                        entity.packageName = packageName
                                    }

                                    self.tryToExportWithLangName("Java")
        }
    }
    
    @IBAction func exportToAndroidKotlin(_ sender: AnyObject!)
    {
        tryToExportWithLangName("Kotlin")
    }
    
    func tryToExportWithLangName(_ langName: String)
    {
        if validEntities() {
            let lang = langWithName(langName)
            let files = EntityFilesGenerator.instance.entitiesToFiles(entities, lang: lang)
            choosePathAndSaveFiles(files)
        }
    }
    
    func langWithName(_ langName: String) -> LangModel
    {
        //        let fileName = "\(langName).json"
        let filePathUrl = Bundle.main.url(forResource: langName, withExtension: "json")!
        let data = try? Data(contentsOf: filePathUrl)
        let jsonObject = (try! JSONSerialization.jsonObject(with: data!, options: [])) as! NSDictionary
        let lang = LangModel(fromDictionary: jsonObject)
        return lang
    }
    
    
    //MARK: - Showing the open panel and save files
    func choosePathAndSaveFiles(_ files: [FileModel])
        {
            let openPanel = NSOpenPanel()
            openPanel.allowsOtherFileTypes = false
            openPanel.treatsFilePackagesAsDirectories = false
            openPanel.canChooseFiles = false
            openPanel.canChooseDirectories = true
            openPanel.canCreateDirectories = true
            openPanel.prompt = "Choose"
            openPanel.beginSheetModal(for: view.window!) { (response) in
                if response == NSApplication.ModalResponse.OK {
                    self.saveFiles(files, toPath:openPanel.url!.path)
                }
            }
        }
    
    
    /**
    Saves all the generated files in the specified path
    
    - parameter path: in which to save the files
    */
    func saveFiles(_ files:[FileModel], toPath path: String)
    {
        var error : NSError?
        
        for file in files{
            
            let filePath = "\(path)/\(file.fileName!).\(file.fileExtension!)"
            
            do {
                try file.fileContent.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
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
        notification.deliveryDate = Date()
        
        let center = NSUserNotificationCenter.default
        center.delegate = self
        center.deliver(notification)
    }
    
    //MARK: - NSUserNotificationCenterDelegate
    func userNotificationCenter(_ center: NSUserNotificationCenter,
        shouldPresent notification: NSUserNotification) -> Bool
    {
        return true
    }

    /**
     Ask user to input package name
     */

    func showDialogToInputPackage(withTitle title: String, information: String, placeholder: String, completion: ((String?)->())? = nil) {

        let alert = NSAlert()
        alert.addButton(withTitle: "OK")      // 1st button
        alert.addButton(withTitle: "Cancel")  // 2nd button
        alert.messageText = title
        alert.informativeText = information

        let textfield = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textfield.placeholderString = placeholder

        alert.accessoryView = textfield
        let response: NSApplication.ModalResponse = alert.runModal()

        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
            completion?(textfield.stringValue)
        }
    }
    
}

