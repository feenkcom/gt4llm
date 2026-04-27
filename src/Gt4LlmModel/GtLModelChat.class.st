Class {
	#name : #GtLModelChat,
	#superclass : #GtLChat,
	#instVars : [
		'model',
		'parameters'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #'api - message' }
GtLModelChat >> createUserMessage [

	^ GtLModelUserMessage new
		chat: self
]

{ #category : #accessing }
GtLModelChat >> model [
	^ model
]

{ #category : #accessing }
GtLModelChat >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLModelChat >> parameters [

	^ parameters ifNil: [ parameters := Dictionary new ]
]

{ #category : #accessing }
GtLModelChat >> provider [

	^ model provider
]

{ #category : #accessing }
GtLModelChat >> provider: aProvider [

	self assert: aProvider == model provider
		description: 'Invalid GtLProvider'.
]

{ #category : #accessing }
GtLModelChat >> reasoningEffort: aValue [

	model userMessageEndpoint validateReasoning: aValue.
	^ super reasoningEffort: aValue
]

{ #category : #'api - message' }
GtLModelChat >> sendString: aString [
	| newMessage |
	self assert: aString isString.
	newMessage := GtLModelUserMessage new chat: self.
	newMessage string: aString.
	self sendMessage: newMessage
]
