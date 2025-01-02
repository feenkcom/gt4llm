Class {
	#name : #GtOpenAIError,
	#superclass : #GtLlmError,
	#instVars : [
		'type',
		'param',
		'code'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
GtOpenAIError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type');
		param: (aDictionary at: 'param');
		code: (aDictionary at: 'code')
]

{ #category : #accessing }
GtOpenAIError >> code [
	^ code
]

{ #category : #accessing }
GtOpenAIError >> code: anObject [
	code := anObject
]

{ #category : #accessing }
GtOpenAIError >> param [
	^ param
]

{ #category : #accessing }
GtOpenAIError >> param: anObject [
	param := anObject
]

{ #category : #accessing }
GtOpenAIError >> type [
	^ type
]

{ #category : #accessing }
GtOpenAIError >> type: anObject [
	type := anObject
]
