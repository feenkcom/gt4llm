Class {
	#name : #GtLlmActionReference,
	#superclass : #Object,
	#instVars : [
		'action',
		'isInput',
		'isOutput'
	],
	#category : #'Gt4Llm-OldTutor'
}

{ #category : #accessing }
GtLlmActionReference >> action [
	^ action
]

{ #category : #accessing }
GtLlmActionReference >> action: anObject [
	action := anObject
]

{ #category : #accessing }
GtLlmActionReference >> initialize [
	super initialize.
	
	isInput := false.
	isOutput := false
]

{ #category : #accessing }
GtLlmActionReference >> isInput [
	^ isInput
]

{ #category : #accessing }
GtLlmActionReference >> isOutput [
	^ isOutput
]

{ #category : #accessing }
GtLlmActionReference >> markInput [
	isInput := true
]

{ #category : #accessing }
GtLlmActionReference >> markOutput [
	isOutput := true
]
