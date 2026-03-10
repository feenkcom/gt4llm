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

{ #category : #private }
GtLMagritteToolForClassesCreation >> createClassFromRequest: aRequest [
	| creationData |
	
	creationData := GtLClassCreationData new.
	creationData request: aRequest.
	
	self extractDataInto: creationData ifError: [ :anError | ^ anError ].
	^ self createClassUsing: creationData ifError: [ :anError | ^ anError ]
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> createClassUsing: creationData ifError: errorBlock [
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
				instanceVariableNames: (creationData instanceVariables 
					collect: [:each | each name ]) asArray;
				classVariableNames: (creationData classVariables 
					collect: [:each | each name]) asArray;
				freeze: error) ].
	
	^ GtLClassModificationResult new
		originalClass: nil;
		updatedClass: (GtLClassDefinitionDescription fromClass: createdClass);
		yourself
]

{ #category : #accessing }
GtLMagritteToolForClassesCreation >> description [
	^ 'Creates multiple classes in a single request and reports each result.

Example JSON arguments:
{
  "classes": [
    {"targetClassName": "MyClass", "superclassName": "Object", "package": "MyPackage"},
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

{ #category : #private }
GtLMagritteToolForClassesCreation >> extractCommentInto: creationData [
	| request commentValue commentString |
	request := creationData request.
	
	commentValue := request comment.
	commentString := commentValue ifNil: [ nil ] ifNotNil: [ commentValue asString trimBoth ].
	(commentString notNil and: [ commentString isEmpty ]) ifTrue: [ commentString := nil ].
	
	creationData comment: commentString
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> extractDataInto: creationData ifError: errorBlock [
	self extractTargetClassNameInto: creationData ifError: errorBlock.
	self extractSuperclassInto: creationData ifError: errorBlock.
	self extractVariablesInto: creationData.
	self extractTraitCompositionInto: creationData.
	self extractPackageInto: creationData ifError: errorBlock.
	self extractCommentInto: creationData
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> extractPackageInto: creationData ifError: errorBlock [
	| request packageValue packageName |
	request := creationData request.
	
	packageValue := request package.
	packageName := (packageValue ifNil: [ '' ]) asString trimBoth.
	packageName isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'package') ].
	
	creationData packageName: packageName
]

{ #category : #'private - extraction' }
GtLMagritteToolForClassesCreation >> extractSuperclassInto: creationData ifError: errorBlock [
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
GtLMagritteToolForClassesCreation >> extractTargetClassNameInto: creationData ifError: errorBlock [
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
GtLMagritteToolForClassesCreation >> extractTraitCompositionInto: creationData [
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
GtLMagritteToolForClassesCreation >> extractVariablesInto: creationData [
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
GtLMagritteToolForClassesCreation >> name [
	^ 'createClasses'
]

{ #category : #private }
GtLMagritteToolForClassesCreation >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| classCreationRequests classResults |
	
	classCreationRequests := aToolCall arguments at: 'classes'.
	classResults := classCreationRequests collect: [ :request |
		self createClassFromRequest: request ].
		
	^ GtLClassesCreationResult new 
			classes: classResults asArray
]
