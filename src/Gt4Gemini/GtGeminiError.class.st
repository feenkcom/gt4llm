Class {
	#name : #GtGeminiError,
	#superclass : #GtLlmError,
	#instVars : [
		'status',
		'code'
	],
	#category : #Gt4Gemini
}

{ #category : #'as yet unclassified' }
GtGeminiError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		status: (aDictionary at: 'status');
		code: (aDictionary at: 'code')
]

{ #category : #accessing }
GtGeminiError >> code [
	^ code
]

{ #category : #accessing }
GtGeminiError >> code: anObject [
	code := anObject
]

{ #category : #accessing }
GtGeminiError >> status [
	^ status
]

{ #category : #accessing }
GtGeminiError >> status: anObject [
	status := anObject
]
