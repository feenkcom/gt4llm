Class {
	#name : #GtLModelApiUserCommand,
	#superclass : #GtLModelApiCommand,
	#instVars : [
		'messages',
		'format',
		'tools',
		'instructions'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelApiUserCommand >> format [
	^ format
]

{ #category : #accessing }
GtLModelApiUserCommand >> format: anObject [
	format := anObject
]

{ #category : #accessing }
GtLModelApiUserCommand >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLModelApiUserCommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLModelApiUserCommand >> messages [
	^ messages
]

{ #category : #accessing }
GtLModelApiUserCommand >> messages: anObject [
	messages := anObject
]

{ #category : #'as yet unclassified' }
GtLModelApiUserCommand >> request [
	<return: #GtLRequestResponse>
	| chatEndpoint context |

	chatEndpoint := model userMessageEndpoint.
	context := model newEndpointContext.
	context command: self.
	^ self client 
		post: chatEndpoint path
		withEntity: (chatEndpoint entityFromContext: context)
]

{ #category : #accessing }
GtLModelApiUserCommand >> serializationClass [
	^ GtLOllamaResponse
]

{ #category : #accessing }
GtLModelApiUserCommand >> tools [
	^ tools
]

{ #category : #accessing }
GtLModelApiUserCommand >> tools: anObject [
	tools := anObject
]
