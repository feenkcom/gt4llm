"
Magritte-based tool for creating a single class.
"
Class {
	#name : #GtLMagritteToolForClassCreation,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #magritte }
GtLMagritteToolForClassCreation >> classCreationRequestDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		accessor: #classCreationRequest;
		classes: { GtLClassCreationRequest };
		beRequired
]

{ #category : #private }
GtLMagritteToolForClassCreation >> createClassUsing: creationData ifError: errorBlock [
	| createdClass |
	
	createdClass := [ creationData superclass classInstaller
		make: [ :builder |
			builder
				superclass: creationData superclass;
				name: creationData targetClassName;
				slots: creationData instanceVariables;
				sharedVariables: creationData classVariables;
				traitComposition: creationData traitComposition;
				package: creationData packageName;
				comment: creationData comment;
				environment: creationData superclass environment ] ]
		on: Error
		do: [ :error |
			^ errorBlock value: (GtLCouldNotCreateClassDomainObject new
				superclass: creationData superclass;
				targetClassName: creationData targetClassName;
				packageName: creationData packageName;
				instanceVariableNames: (creationData instanceVariables collect: #name) asArray;
				classVariableNames: (creationData classVariables collect: #name) asArray;
				freeze: error) ].
	
	^ GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription fromClass: createdClass);
		yourself
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> description [
	^ 'Creates a single class with the provided superclass, variables, traits, and package.

Example JSON arguments:
{
  "classCreationRequest": {
    "targetClassName": "MyClass",
    "superclassName": "Object",
    "package": "MyPackage",
    "instanceVariables": "slot1 slot2",
    "classVariables": "SharedValue",
    "traitCompositionString": "{}",
    "comment": "A description of the class"
  }
}

Example JSON response:
{
  "currentClassName": "MyClass",
  "superclassName": "Object",
  "packageName": "MyPackage",
  "instanceSlotNames": ["slot1", "slot2"],
  "classSlotNames": [],
  "classVariableNames": ["SharedValue"],
  "traitCompositionString": "{}",
  "comment": "A description of the class"
}'
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractCommentInto: creationData [
	| request commentValue commentString |
	request := creationData request.
	
	commentValue := request comment.
	commentString := commentValue ifNil: [ nil ] ifNotNil: [ commentValue asString trimBoth ].
	(commentString notNil and: [ commentString isEmpty ]) ifTrue: [ commentString := nil ].
	
	creationData comment: commentString
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractDataInto: creationData ifError: errorBlock [
	self extractTargetClassNameInto: creationData ifError: errorBlock.
	self extractSuperclassInto: creationData ifError: errorBlock.
	self extractVariablesInto: creationData.
	self extractTraitCompositionInto: creationData.
	self extractPackageInto: creationData ifError: errorBlock.
	self extractCommentInto: creationData
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractPackageInto: creationData ifError: errorBlock [
	| request packageValue packageName |
	request := creationData request.
	
	packageValue := request package.
	packageName := (packageValue ifNil: [ '' ]) asString trimBoth.
	packageName isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'package') ].
	
	creationData packageName: packageName
]

{ #category : #'private - extraction' }
GtLMagritteToolForClassCreation >> extractSuperclassInto: creationData ifError: errorBlock [
	| request superclassValue superclassName |
	request := creationData request.
	
	superclassValue := request superclassName.
	superclassName := (superclassValue ifNil: [ '' ]) asString trimBoth.
	superclassName isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'superclassName') ].
	
	creationData superclass: (Smalltalk globals
		at: superclassName asSymbol
		ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: superclassName) ])
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractTargetClassNameInto: creationData ifError: errorBlock [
	| request classNameValue classNameString classNameSymbol |
	request := creationData request.
	
	classNameValue := request targetClassName.
	classNameString := (classNameValue ifNil: [ '' ]) asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'targetClassName') ].
	
	classNameSymbol := classNameString asSymbol.
	
	(Smalltalk globals includesKey: classNameSymbol)
		ifTrue: [ ^ errorBlock value: (GtLUnexpectedDomainObject new objectName: classNameString) ].
	
	creationData targetClassName: classNameSymbol
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractTraitCompositionInto: creationData [
	| request traitCompositionValue traitCompositionString |
	request := creationData request.
	
	traitCompositionValue := request traitCompositionString.
	traitCompositionString := traitCompositionValue ifNil: [ Behavior traitCompositionString ].
	traitCompositionString := traitCompositionString asString trimBoth.
	traitCompositionString isEmpty
		ifTrue: [ traitCompositionString := Behavior traitCompositionString ].
	
	creationData traitComposition: (self class compiler evaluate: traitCompositionString)
]

{ #category : #private }
GtLMagritteToolForClassCreation >> extractVariablesInto: creationData [
	| request instanceVars classVars |
	request := creationData request.
	
	instanceVars := request instanceVariables.
	creationData instanceVariables: (instanceVars
		ifNil: [ #() ]
		ifNotNil: [ 
			(instanceVars isString or: [ instanceVars isSymbol ])
				ifTrue: [ instanceVars asString asSlotCollection ]
				ifFalse: [ instanceVars collect: [ :each | each asSymbol asSlot ] ] ]).
	
	classVars := request classVariables.
	creationData classVariables: (classVars
		ifNil: [ #() ]
		ifNotNil: [ 
			(classVars isString or: [ classVars isSymbol ])
				ifTrue: [ classVars asString asClassVariableCollection ]
				ifFalse: [ classVars collect: [ :each | each asSymbol asClassVariable ] ] ])
]

{ #category : #accessing }
GtLMagritteToolForClassCreation >> name [
	^ 'createClass'
]

{ #category : #actions }
GtLMagritteToolForClassCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| creationData |
	
	creationData := GtLClassCreationData new.
	creationData request: (aToolCall arguments at: 'classCreationRequest').
	
	self extractDataInto: creationData ifError: [ :anError | ^ anError ].
	^ self createClassUsing: creationData ifError: [ :anError | ^ anError ]
]
