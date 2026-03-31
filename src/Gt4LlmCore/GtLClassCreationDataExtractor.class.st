"
Extracts and holds intermediate data needed to create a class from a GtLClassCreationRequest.
"
Class {
	#name : #GtLClassCreationDataExtractor,
	#superclass : #Object,
	#instVars : [
		'request',
		'targetClassName',
		'superclass',
		'classVariables',
		'traitComposition',
		'packageName',
		'comment',
		'packageTagName',
		'instanceSlots',
		'classSlots'
	],
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLClassCreationDataExtractor >> classInstanceVariables [
	^ classSlots
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> classInstanceVariables: aCollection [
	classSlots := aCollection
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> classVariables [
	^ classVariables
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> classVariables: aCollection [
	classVariables := aCollection
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> comment [
	^ comment
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> comment: aString [
	comment := aString
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractAllIfError: errorBlock [
	"Extract all data from the request.
	Calls errorBlock for validation errors."
	
	self extractTargetClassNameIfError: errorBlock.
	self extractSuperclassIfError: errorBlock.
	self extractVariables.
	self extractTraitComposition.
	self extractPackageIfError: errorBlock.
	self extractPackageTagIfError: errorBlock.
	self extractComment
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractComment [
	"Extract the comment from the request."
	| commentValue commentString |
	
	commentValue := request comment.
	commentString := commentValue ifNil: [ nil ] ifNotNil: [ commentValue asString trimBoth ].
	(commentString notNil and: [ commentString isEmpty ]) ifTrue: [ commentString := nil ].
	
	comment := commentString
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractPackageIfError: errorBlock [
	"Extract and validate the package name from the request."
	| packageValue pkgName |
	
	packageValue := request package.
	pkgName := (packageValue ifNil: [ '' ]) asString trimBoth.
	pkgName isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'package') ].
	
	packageName := pkgName
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractPackageTagIfError: errorBlock [
	"Extract and validate the package tag name from the request."

	| packageTagValue pkgTagName |
	packageTagValue := request packageTag.
	pkgTagName := (packageTagValue ifNil: [ '' ]) asString trimBoth.
	pkgTagName isEmpty
		ifTrue: [ packageTagName := nil ]
		ifFalse: [ packageTagName := pkgTagName ]
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractSuperclassIfError: errorBlock [
	"Extract and validate the superclass from the request."
	| superclassValue superclassName |
	
	superclassValue := request superclassName.
	superclassName := (superclassValue ifNil: [ '' ]) asString trimBoth.
	superclassName isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'superclassName') ].
	
	superclass := Smalltalk globals
		at: superclassName asSymbol
		ifAbsent: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: superclassName) ]
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractTargetClassNameIfError: errorBlock [
	"Extract and validate the target class name from the request."
	| classNameValue classNameString classNameSymbol |
	
	classNameValue := request targetClassName.
	classNameString := (classNameValue ifNil: [ '' ]) asString trimBoth.
	classNameString isEmpty
		ifTrue: [ ^ errorBlock value: (GtLMissingDomainObject new objectName: 'targetClassName') ].
	
	classNameSymbol := classNameString asSymbol.
	
	(Smalltalk globals includesKey: classNameSymbol)
		ifTrue: [ ^ errorBlock value: (GtLUnexpectedDomainObject new 
			objectName: classNameString) ].
	
	targetClassName := classNameSymbol
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractTraitComposition [
	"Extract the trait composition from the request."
	| traitCompositionValue traitCompositionString |
	
	traitCompositionValue := request traitCompositionString.
	traitCompositionString := traitCompositionValue ifNil: [ Behavior traitCompositionString ].
	traitCompositionString := traitCompositionString asString trimBoth.
	traitCompositionString isEmpty
		ifTrue: [ traitCompositionString := Behavior traitCompositionString ].
	
	traitComposition := self class compiler evaluate: traitCompositionString
]

{ #category : #extraction }
GtLClassCreationDataExtractor >> extractVariables [
	"Extract instance and class variables from the request."
	| instanceSlotNames classVars classSlotNames |
	
	instanceSlotNames := request instanceVariables.
	instanceSlots := instanceSlotNames
		ifNil: [ #() ]
		ifNotNil: [ 
			(instanceSlotNames isString or: [ instanceSlotNames isSymbol ])
				ifTrue: [ instanceSlotNames asString asSlotCollection ]
				ifFalse: [ instanceSlotNames collect: [ :each | each asSymbol asSlot ] ] ].
				
	classSlotNames := request classInstanceVariables.
	classSlots := classSlotNames
		ifNil: [ #() ]
		ifNotNil: [ 
			(classSlotNames isString or: [ classSlotNames isSymbol ])
				ifTrue: [ classSlotNames asString asSlotCollection ]
				ifFalse: [ classSlotNames collect: [ :each | each asSymbol asSlot ] ] ].
	
	classVars := request classVariables.
	classVariables := classVars
		ifNil: [ #() ]
		ifNotNil: [ 
			(classVars isString or: [ classVars isSymbol ])
				ifTrue: [ classVars asString asClassVariableCollection ]
				ifFalse: [ classVars collect: [ :each | each asSymbol asClassVariable ] ] ]
]

{ #category : #views }
GtLClassCreationDataExtractor >> gtDetailsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Details';
		priority: 10;
		items: [
			{ 'Request' -> request.
			  'Target class name' -> targetClassName.
			  'Superclass' -> superclass.
			  'Instance slots' -> instanceSlots.
			  'Class slots' -> classSlots.
			  'Class variables' -> classVariables.
			  'Trait composition' -> traitComposition.
			  'Package name' -> packageName.
			  'Package tag name' -> packageTagName.
			  'Comment' -> comment } ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> instanceVariables [
	^ instanceSlots
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> instanceVariables: aCollection [
	instanceSlots := aCollection
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> packageName [
	^ packageName
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> packageName: aString [
	packageName := aString
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> packageTagName [
	^ packageTagName
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> packageTagName: aString [
	packageTagName := aString
]

{ #category : #printing }
GtLClassCreationDataExtractor >> printOn: aStream [
	aStream nextPutAll: 'aGtLClassCreationDataExtractor'.
	targetClassName ifNotNil: [ 
		aStream
			nextPutAll: ' (';
			nextPutAll: targetClassName;
			nextPut: $) ]
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> request [
	^ request
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> request: aGtLClassCreationRequest [
	request := aGtLClassCreationRequest
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> superclass [
	^ superclass
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> superclass: aClass [
	superclass := aClass
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> targetClassName [
	^ targetClassName
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> targetClassName: aSymbol [
	targetClassName := aSymbol
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> traitComposition [
	^ traitComposition
]

{ #category : #accessing }
GtLClassCreationDataExtractor >> traitComposition: aTraitComposition [
	traitComposition := aTraitComposition
]
