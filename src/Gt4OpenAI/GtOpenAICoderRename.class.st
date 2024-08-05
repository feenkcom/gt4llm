Class {
	#name : #GtOpenAICoderRename,
	#superclass : #Object,
	#instVars : [
		'type',
		'original',
		'proposals'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAICoderRename >> isForMethod [
	^ self type = 'method'
]

{ #category : #accessing }
GtOpenAICoderRename >> isForVariable [
	^ self type = 'variable'
]

{ #category : #accessing }
GtOpenAICoderRename >> original [
	^ original
]

{ #category : #accessing }
GtOpenAICoderRename >> original: anObject [
	original := anObject
]

{ #category : #accessing }
GtOpenAICoderRename >> proposals [
	^ proposals
]

{ #category : #accessing }
GtOpenAICoderRename >> proposals: anObject [
	proposals := anObject
]

{ #category : #accessing }
GtOpenAICoderRename >> type [
	^ type
]

{ #category : #accessing }
GtOpenAICoderRename >> type: anObject [
	type := anObject
]
