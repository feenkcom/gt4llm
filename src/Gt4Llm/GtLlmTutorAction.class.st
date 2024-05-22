Class {
	#name : #GtLlmTutorAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'examples',
		'pipeline',
		'description'
	],
	#category : #'Gt4Llm-Actions'
}

{ #category : #accessing }
GtLlmTutorAction >> asInstruction [
	^ GtLlmInstructionSection new
		source: self;
		title: self name;
		body: (GtLlmCompositeInstruction new
				addItem: self description;
				addItem: (GtLlmInstructionSection new
						source: self;
						title: 'Examples';
						body: (GtLlmCompositeInstruction new
								items: (self examples
										flatCollect: [ :each | 
											{'INSTRUCTION: ' , each key.
												'OUTPUT:
' , each value} ]))))
]

{ #category : #accessing }
GtLlmTutorAction >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorAction >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> examples [
	^ examples
]

{ #category : #accessing }
GtLlmTutorAction >> examples: anObject [
	examples := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> gtInstructionFor: aView [
	<gtView>
	^ aView forward
		title: 'Instruction';
		priority: 1;
		object: [self asInstruction ];
		view: #gtInstructionFor:
]

{ #category : #accessing }
GtLlmTutorAction >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorAction >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline [
	^ pipeline
]

{ #category : #accessing }
GtLlmTutorAction >> pipeline: anObject [
	pipeline := anObject
]
