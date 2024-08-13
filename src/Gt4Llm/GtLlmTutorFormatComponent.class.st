Class {
	#name : #GtLlmTutorFormatComponent,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'tag',
		'example',
		'priority',
		'actions',
		'tutor'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorFormatComponent >> actions [
	^ actions
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> addReference: aReference [
	(actions includes: aReference) ifFalse: [ actions add: aReference ]
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
	^ {'type' -> 'string'.
		'description'
			-> (GtLlmInstructionList new
					addItem: 'Format: ' , self format;
					addItem: 'Examples:
' , self example) instructionString} asDictionary
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> defaultPriority [
	^ 10
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
	^ aView forward
		title: 'Referencing actions';
		priority: 5;
		object: [ actions ];
		view: #gtActionsFor:
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		priority: 1;
		object: [ self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> initialize [
	super initialize.
	
	priority := self defaultPriority.
	
	actions := GtLlmActionsGroup new
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
