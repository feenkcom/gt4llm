Class {
	#name : #Gt4OpenAIError,
	#superclass : #Error,
	#instVars : [
		'type',
		'param',
		'code'
	],
	#category : #'Gt4OpenAI-Client'
}

{ #category : #accessing }
Gt4OpenAIError class >> from: aDictionary [
	^ self new
		messageText: (aDictionary at: 'message');
		type: (aDictionary at: 'type');
		param: (aDictionary at: 'param');
		code: (aDictionary at: 'code')
]

{ #category : #accessing }
Gt4OpenAIError >> code [
	^ code
]

{ #category : #accessing }
Gt4OpenAIError >> code: anObject [
	code := anObject
]

{ #category : #'gt - extensions' }
Gt4OpenAIError >> gtMessageTextFor: aView [
	<gtExceptionDebuggingView>
	^ super gtMessageTextFor: aView
]

{ #category : #accessing }
Gt4OpenAIError >> param [
	^ param
]

{ #category : #accessing }
Gt4OpenAIError >> param: anObject [
	param := anObject
]

{ #category : #accessing }
Gt4OpenAIError >> type [
	^ type
]

{ #category : #accessing }
Gt4OpenAIError >> type: anObject [
	type := anObject
]
