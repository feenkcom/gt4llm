Class {
	#name : #GtLlmTutorFormatComponent,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'tag',
		'example',
		'priority'
	],
	#category : #'Gt4Llm-Tutor'
}

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
GtLlmTutorFormatComponent >> gtInstructionFor: aView [
	<gtView>
	^ aView forward 
		title: 'Instruction';
		object: [ self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorFormatComponent >> initialize [
	super initialize.
	
	priority := self defaultPriority
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
