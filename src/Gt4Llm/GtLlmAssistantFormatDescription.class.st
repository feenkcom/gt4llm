Class {
	#name : #GtLlmAssistantFormatDescription,
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
		'items',
		'assistant'
	],
	#category : #Gt4Llm
}

{ #category : #other }
GtLlmAssistantFormatDescription class >> new [
	^ self basicNew initialize
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> addInputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markInput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markInput action: anAction) ]
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> addOutputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markOutput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markOutput action: anAction) ]
]

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatDescription >> asExpressionSource [
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
GtLlmAssistantFormatDescription >> asInstructionPiece [
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Examples:
' , (self example ifNil: [ 'none' ]))
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> asJsonSchema [
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

{ #category : #accessing }
GtLlmAssistantFormatDescription >> assistant [
	^ assistant
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> assistant: anObject [
	assistant := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatDescription >> beRequired [
	self type remove: 'null' ifAbsent: [  ]
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> defaultPriority [
	^ 10
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> defaultType [
	^ {'string'.
		'null'}
]

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatDescription >> definingMethod [
	^ definingMethod
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> example [
	^ example
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> format [
	^ format
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> gtActionsFor: aView [
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
GtLlmAssistantFormatDescription >> gtDefinitionFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 2;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> initialize [
	super initialize.
	
	priority := self defaultPriority.
	
	type := self defaultType asOrderedCollection.
	
	referencingActions := OrderedCollection new.
	
	definingMethod := self initializeMethod
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> items [
	^ items
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> items: anObject [
	items := anObject
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> name [
	^ name
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatDescription >> removeFromSystem [
	self definingMethod ifNotNil: [ :aMethod | aMethod removeFromSystem ]
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> type [
	^ type
]

{ #category : #accessing }
GtLlmAssistantFormatDescription >> type: anObject [
	type := anObject
]
