Class {
	#name : #GtLlmTutorStep,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'rules'
	],
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmTutorStep >> asRuleString [
	^ self name , ': ' , self description , ' [RULES: ' , self rules , ']'
]

{ #category : #accessing }
GtLlmTutorStep >> description [
	^ description
]

{ #category : #accessing }
GtLlmTutorStep >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> name [
	^ name
]

{ #category : #accessing }
GtLlmTutorStep >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmTutorStep >> rules [
	^ rules
]

{ #category : #accessing }
GtLlmTutorStep >> rules: anObject [
	rules := anObject
]
