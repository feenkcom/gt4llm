Class {
	#name : #GtLlmTransformationDescription,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'example',
		'transformation'
	],
	#category : #'Gt4Llm-Refactoring-Assistants'
}

{ #category : #accessing }
GtLlmTransformationDescription >> description [
	^ description
]

{ #category : #accessing }
GtLlmTransformationDescription >> description: aString [
	description := aString
]

{ #category : #accessing }
GtLlmTransformationDescription >> example [
	^ example
]

{ #category : #accessing }
GtLlmTransformationDescription >> example: aDictionary [
	example := aDictionary
]

{ #category : #accessing }
GtLlmTransformationDescription >> name [
	^ name
]

{ #category : #accessing }
GtLlmTransformationDescription >> name: aString [
	name := aString
]

{ #category : #accessing }
GtLlmTransformationDescription >> transformation [
	^ transformation
]

{ #category : #accessing }
GtLlmTransformationDescription >> transformation: aBlock [
	transformation := aBlock
]
