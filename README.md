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

![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888257/55f0820c-a400-11e4-97cf-3c43dfaed7cf.png)
![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888258/55f51f9c-a400-11e4-8de7-2fbd1f0b5eec.png)
![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888259/56060cd0-a400-11e4-9c90-2a3cf4266697.png)
![alt tag](https://cloud.githubusercontent.com/assets/5157350/5888380/712ddd6c-a405-11e4-8d49-870d8b0ffe4a.png)

Installation
========================
Kindly clone the project, and build it using Xcode 6.1+ on any Mac OS X 10.10 or above.

To Do
========================
* Preview the entities and their relationships in graph-alike diagram.
* Support undo and redo.


History log:
========================
* Version 0.0.3
  - Fixed issue #3 which causes default values to disappear.
  - Merged PR #6 to add support for Kotlin language.
  
* Version 0.0.2
  - Minor fixes including Swift 1.2 compatability.

* Version 0.0.1:
  - Initial release.


License
========================
Realm Object Editor is available under **MIT** license.
