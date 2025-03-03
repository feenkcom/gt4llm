Class {
	#name : #Gt4LlmHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#classVars : [
		'ShouldShowSection'
	],
	#category : #Gt4Llm
}

{ #category : #settings }
Gt4LlmHomeSection class >> hideSection [
	self shouldShowSection:  false.
	GtWorld requestAllInstancesHomeUpdate
]

{ #category : #settings }
Gt4LlmHomeSection class >> shouldShowSection [
	^ ShouldShowSection ifNil: [ false ]
]

{ #category : #settings }
Gt4LlmHomeSection class >> shouldShowSection: aBoolean [
	ShouldShowSection := aBoolean
]

{ #category : #settings }
Gt4LlmHomeSection class >> showSection [
	self shouldShowSection:  true.
	GtWorld requestAllInstancesHomeUpdate
]

{ #category : #accessing }
Gt4LlmHomeSection >> sectionTitle [
	^ 'Glamorous Toolkit for Large Language Models'
]
