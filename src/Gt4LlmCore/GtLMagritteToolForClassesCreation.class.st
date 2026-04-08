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
	^ 'Creates multiple classes and traits in a single request and reports each result. 
Trait names usually starts with "T".

Example JSON arguments:
{
  "classes": [
    {"targetClassName": "MyClass", "superclassName": "Object", "package": "MyPackage", "packageTag": "MyTag", "traitComposition": "{TMyTrait}"},
    {"targetClassName": "MySubclass", "superclassName": "MyClass", "package": "MyPackage", "instanceVariables": "value", "classInstanceVariables": "valueTwo"}
  ],
  "traits": [
    {"targetTraitName": "TMyTrait", "package": "MyPackage", "packageTag": "MyTag", "traitComposition": "{}"},
    {"targetTraitName": "TMyTraitTwo", "package": "MyPackage", "instanceVariables": "value", "classInstanceVariables": "valueTwo", "traitComposition": "{TMyTrait}"}
  ]
}

Example JSON response:
{
  "classes": [
    {"currentClassName": "MyClass", "superclassName": "Object", "packageName": "MyPackage", "packageTag": "MyTag", "instanceSlotNames": [], "classSlotNames": [], "classVariableNames": [], "traitCompositionString": "{TMyTrait}"},
    {"currentClassName": "MySubclass", "superclassName": "MyClass", "packageName": "MyPackage", "instanceSlotNames": ["value"], "classSlotNames": [ "valueTwo" ], "traitCompositionString": "{}"}
  ],
  "traits": [
    {"currentTraitName": "TMyTrait", "packageName": "MyPackage", "instanceSlotNames": [], "classSlotNames": [], "traitCompositionString": "{}"},
    {"currentTraitName": "TMyTraitTwo", "packageName": "MyPackage", "instanceSlotNames": ["value"], "classSlotNames": ["valueTwo"], "traitCompositionString": "{TMyTrait}"}
  ]
}'
]

{ #category : #accessing }
GtLMagritteToolForClassesCreation >> name [
	^ 'createClassesAndTraits'
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| classCreationRequests classResults creationTool traitsCreationRequests traitsResults |
	
	creationTool := GtLMagritteToolForClassCreation new.
	
	traitsCreationRequests := aToolCall arguments at: 'traits'.
	traitsResults := traitsCreationRequests collect: [ :request |
		creationTool createClassFromRequest: request ].
	
	classCreationRequests := aToolCall arguments at: 'classes'.
	classResults := classCreationRequests collect: [ :request |
		creationTool createClassFromRequest: request ].
		
	^ GtLClassesCreationResult new 
			classes: traitsResults asArray, classResults asArray
]

{ #category : #'magritte-description' }
GtLMagritteToolForClassesCreation >> traitsDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		accessor: #traits;
		classes: { GtLTraitCreationRequest };
		beRequired
]
