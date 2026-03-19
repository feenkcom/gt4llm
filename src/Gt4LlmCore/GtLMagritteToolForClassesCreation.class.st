"
Magritte-based tool for creating multiple classes in a single request.
"
Class {
	#name : #GtLMagritteToolForClassesCreation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'magritte-description' }
GtLMagritteToolForClassesCreation >> classesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #classes;
		classes: { GtLClassCreationRequest };
		beRequired
]

{ #category : #accessing }
GtLMagritteToolForClassesCreation >> description [
	^ 'Creates multiple classes in a single request and reports each result.

Example JSON arguments:
{
  "classes": [
    {"targetClassName": "MyClass", "superclassName": "Object", "package": "MyPackage", "packageTag": "MyTag", "traitComposition": "TMyTrait"},
    {"targetClassName": "MySubclass", "superclassName": "MyClass", "package": "MyPackage", "instanceVariables": "value", "classVariables": "SharedValue"}
  ]
}

Example JSON response:
{
  "classes": [
    {"currentClassName": "MyClass", "superclassName": "Object", "packageName": "MyPackage", "instanceSlotNames": [], "classSlotNames": [], "classVariableNames": [], "traitCompositionString": "{}"},
    {"currentClassName": "MySubclass", "superclassName": "MyClass", "packageName": "MyPackage", "instanceSlotNames": ["value"], "classSlotNames": [], "classVariableNames": ["SharedValue"], "traitCompositionString": "{}"}
  ]
}'
]

{ #category : #accessing }
GtLMagritteToolForClassesCreation >> name [
	^ 'createClasses'
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| classCreationRequests classResults creationTool |
	
	classCreationRequests := aToolCall arguments at: 'classes'.
	creationTool := GtLMagritteToolForClassCreation new.
	
	classResults := classCreationRequests collect: [ :request |
		creationTool createClassFromRequest: request ].
		
	^ GtLClassesCreationResult new 
			classes: classResults asArray
]
