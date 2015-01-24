Realm Object Editor
==========
[Realm](http://realm.io) Object Editor is a visual editor where you can create your Realm entities, attributes and relationships inside a nice user interface. Once you finish, you can export your schema document for later use and you can export your objects in Swift, Objective-C and Java.

Using Realm Object Editor you will be able to:
* Create Realm Entities.
* Create the entities attributes and define the properties for each attribute (primary key, index, ignored, default value, etc...)
* Create one-to-one, one-to-many and many-to-many relationships.
* Set a perant class for each entity (the default is RLMObject for cocoa-based entities and RealmObject for Java entities)
* Export the designed schema into Swift, Objective-C or Java for Android.



Generated Files
========================
Each generated file, besid the getters and setters (for Java) will include:
* The defination for the primary key.
* The defination for indexed attributes.
* The defination for the ignored attributes.
* The defination for the desired attributes' default values.

Realm Object Editor in action
========================

The following screenshots should give you an idea of how the ROE works.

![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888032/e45b7afa-a3f7-11e4-985a-7eb7f8f8c063.png)
![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888033/e7b3716c-a3f7-11e4-942f-43c305e999e5.png)

Installation
========================
Kindly clone the project, and build it using xCode 6.1+ on any Mac OS X 10.10 or above.

To Do
========================
* Preview the entities and their relationships in graph-alike diagram.
* Support undo and redo.


History log:
========================
* Version 0.0.1:
  - Initial release.


License
========================
JSONExport is available under **MIT** license.
