Class {
	#name : #GtLOpenAIError,
	#superclass : #GtLError,
	#instVars : [
		'type',
		'param',
		'code'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type');
		param: (aDictionary at: 'param');
		code: (aDictionary at: 'code')
]

{ #category : #accessing }
GtLOpenAIError >> code [
	^ code
]

{ #category : #accessing }
GtLOpenAIError >> code: anObject [
	code := anObject
]

{ #category : #accessing }
GtLOpenAIError >> param [
	^ param
]

{ #category : #accessing }
GtLOpenAIError >> param: anObject [
	param := anObject
]

{ #category : #accessing }
GtLOpenAIError >> type [
	^ type
]

{ #category : #accessing }
GtLOpenAIError >> type: anObject [
	type := anObject
]
