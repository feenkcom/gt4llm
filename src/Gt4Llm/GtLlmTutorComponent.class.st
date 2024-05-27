Class {
	#name : #GtLlmTutorComponent,
	#superclass : #Object,
	#instVars : [
		'name',
		'format',
		'tag',
		'example'
	],
	#category : #'Gt4Llm-Tutor'
}

{ #category : #accessing }
GtLlmTutorComponent >> asInstruction [
	^ GtLlmInstructionSection new
		title: self name;
		body: (GtLlmInstructionList new
				addItem: 'Name: ' , self name;
				addItem: 'Format: ' , self format;
				addItem: 'Markdown code tag: ' , self tag;
				addItem: 'Examples:
' , self example)
]

{ #category : #accessing }
GtLlmTutorComponent >> example [
	^ example
]

{ #category : #accessing }
GtLlmTutorComponent >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLlmTutorComponent >> format [
	^ format
]

{ #category : #accessing }
GtLlmTutorComponent >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLlmTutorComponent >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorComponent >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorComponent >> tag [
	^ tag
]

{ #category : #accessing }
GtLlmTutorComponent >> tag: anObject [
	tag := anObject
]
