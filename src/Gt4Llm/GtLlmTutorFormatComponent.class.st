Class {
	#name : #GtLlmTutorFormatComponent,
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
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorFormatComponent >> addInputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markInput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markInput action: anAction) ]
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> addOutputReference: anAction [
	referencingActions
		detect: [ :aReference | aReference action = anAction ]
		ifFound: [ :aReference | aReference markOutput ]
		ifNone: [ referencingActions
				add: (GtLlmActionReference new markOutput action: anAction) ]
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> asInstruction [
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Examples:
' , self example)
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> asJsonSchema [
	^ {'type' -> self type.
		'description'
			-> (GtLlmInstructionList new
					addItem: 'Format: ' , self format;
					addItem: 'Examples:
' , self example) instructionString} asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatComponent >> beRequired [
	self type remove: 'null' ifAbsent: [  ]
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> defaultPriority [
	^ 10
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> defaultType [
	^ {'string'.
		'null'}
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatComponent >> definingMethod [
	^ definingMethod
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> example [
	^ example
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> format [
	^ format
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> gtActionsFor: aView [
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
GtLlmTutorFormatComponent >> gtDefinitionFor: aView [
	<gtView>
	^ aView forward
		title: 'Definition';
		priority: 1;
		object: [ definingMethod ];
		view: #gtSourceFor:
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 2;
		object: [ self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> initialize [
	super initialize.
	
	priority := self defaultPriority.
	
	type := self defaultType asOrderedCollection.
	
	referencingActions := OrderedCollection new.
	
	definingMethod := (thisContext stack at: 3) blocDefiningMethod
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> priority [
	^ priority
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> priority: anObject [
	priority := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> tutor [
	^ tutor
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> tutor: anObject [
	tutor := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> type [
	^ type
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> type: anObject [
	type := anObject
]
