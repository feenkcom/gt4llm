Class {
	#name : #GtLlmTutorFormatDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'tag',
		'example',
		'priority',
		'tutor',
		'referencingActions',
		'definingMethod',
		'type'
	],
	#category : #'Gt4Llm-Tutor2'
}

{ #category : #accessing }
GtLlmTutorFormatDescription >> addInputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markInput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markInput action: anAction) ]
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> addOutputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markOutput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markOutput action: anAction) ]
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatDescription >> asExpressionSource [
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
GtLlmTutorFormatDescription >> asInstructionPiece [
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Examples:
' , self example)
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> asJsonSchema [
	^ {'type' -> self type.
		'description'
			-> (GtLlmInstructionList new
					addItem: 'Format: ' , self format;
					addItem: 'Examples:
' , self example) instructionString} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatDescription >> beRequired [
	self type remove: 'null' ifAbsent: [  ]
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> defaultPriority [
	^ 10
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> defaultType [
	^ {'string'.
		'null'}
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatDescription >> definingMethod [
	^ definingMethod
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> example [
	^ example
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> format [
	^ format
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> gtActionsFor: aView [
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
GtLlmTutorFormatDescription >> gtDefinitionFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 2;
		object: [ self asInstructionPiece ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> initialize [
	super initialize.
	
	priority := self defaultPriority.
	
	type := self defaultType asOrderedCollection.
	
	referencingActions := OrderedCollection new.
	
	definingMethod := (thisContext stack at: 3) blocDefiningMethod
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatDescription >> removeFromSystem [
	self definingMethod ifNotNil: #removeFromSystem
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> tutor [
	^ tutor
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> tutor: anObject [
	tutor := anObject
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> type [
	^ type
]

{ #category : #accessing }
GtLlmTutorFormatDescription >> type: anObject [
	type := anObject
]
