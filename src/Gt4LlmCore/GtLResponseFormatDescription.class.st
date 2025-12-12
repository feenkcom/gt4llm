Class {
	#name : #GtLResponseFormatDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'tag',
		'example',
		'priority',
		'referencingActions',
		'definingMethod',
		'type',
		'items'
	],
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLResponseFormatDescription >> addInputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markInput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markInput action: anAction) ]
]

{ #category : #accessing }
GtLResponseFormatDescription >> addOutputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markOutput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markOutput action: anAction) ]
]

{ #category : #'as yet unclassified' }
GtLResponseFormatDescription >> asExpressionSource [
	^ self class name
		, ' new
	type: ' , self type storeString
		, ';
	format: ' , self format storeString
		, ';
	name: ' , self name storeString
		, ';
	priority: ' , self priority asString
		, ';
	example: ' , self example storeString
]

{ #category : #accessing }
GtLResponseFormatDescription >> asInstructionPiece [
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Details:
' , (self example ifNil: [ 'none' ]))
]

{ #category : #accessing }
GtLResponseFormatDescription >> asJsonSchema [
	| aDict |
	aDict := {'type' -> self type.
			'description'
				-> (GtLlmInstructionList new
						addItem: 'Format: ' , self format;
						addItem: 'Examples:
' , (self example ifNil: [ 'none' ])) instructionString} asDictionary.	"only relevant for arrays"
	self items ifNotNil: [ aDict at: 'items' put: self items ].

	^ aDict
]

{ #category : #'as yet unclassified' }
GtLResponseFormatDescription >> beRequired [
	self type remove: 'null' ifAbsent: [  ]
]

{ #category : #accessing }
GtLResponseFormatDescription >> defaultPriority [
	^ 10
]

{ #category : #accessing }
GtLResponseFormatDescription >> defaultType [
	^ {'string'}
]

{ #category : #'as yet unclassified' }
GtLResponseFormatDescription >> definingMethod [
	^ definingMethod
]

{ #category : #accessing }
GtLResponseFormatDescription >> example [
	^ example
]

{ #category : #accessing }
GtLResponseFormatDescription >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLResponseFormatDescription >> format [
	^ format
]

{ #category : #accessing }
GtLResponseFormatDescription >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLResponseFormatDescription >> gtActionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Referencing actions';
		priority: 5;
		items: [ referencingActions ];
		column: 'Action' text: [ :aReference | aReference action name ];
		column: 'Input'
			text: [ :aReference | aReference isInput ifTrue: [ 'true' ] ifFalse: [ '' ] ];
		column: 'Output'
			text: [ :aReference | aReference isOutput ifTrue: [ 'true' ] ifFalse: [ '' ] ]
]

{ #category : #'as yet unclassified' }
GtLResponseFormatDescription >> gtDefinitionFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtLResponseFormatDescription >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 2;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLResponseFormatDescription >> initialize [
	super initialize.
	
	priority := self defaultPriority.
	
	type := self defaultType asOrderedCollection.
	
	referencingActions := OrderedCollection new.
	
	definingMethod := self initializeMethod
]

{ #category : #accessing }
GtLResponseFormatDescription >> initializeMethod [
	^ (thisContext stack at: 4) blocDefiningMethod
]

{ #category : #accessing }
GtLResponseFormatDescription >> items [
	^ items
]

{ #category : #accessing }
GtLResponseFormatDescription >> items: anObject [
	items := anObject
]

{ #category : #accessing }
GtLResponseFormatDescription >> name [
	^ name
]

{ #category : #accessing }
GtLResponseFormatDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLResponseFormatDescription >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLResponseFormatDescription >> priority [
	^ priority
]

{ #category : #accessing }
GtLResponseFormatDescription >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
GtLResponseFormatDescription >> removeFromSystem [
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
]

{ #category : #accessing }
GtLResponseFormatDescription >> type [
	^ type
]

{ #category : #accessing }
GtLResponseFormatDescription >> type: anObject [
	type := anObject
]
