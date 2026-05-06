Class {
	#name : #GtLModelApiCommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'context',
		'model'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelApiCommand >> client [

	^ context model client
]

{ #category : #accessing }
GtLModelApiCommand >> context [
	^ context ifNil: [ context := self newContext ].
]

{ #category : #accessing }
GtLModelApiCommand >> context: anObject [
	context := anObject
]

{ #category : #accessing }
GtLModelApiCommand >> model [
	^ model ifNil: [ context model ]
]

{ #category : #accessing }
GtLModelApiCommand >> model: anObject [
	model := anObject
]

{ #category : #'private - accessing' }
GtLModelApiCommand >> newContext [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
GtLModelApiCommand >> perform [
	| requestResponse chatEndpoint |
	
	chatEndpoint := model userMessageEndpoint.
	context := chatEndpoint newContextForModel: model.
	context 
		command: self;
		chat: model provider chat.
	requestResponse := self client 
		post: chatEndpoint path
		withEntity: (chatEndpoint entityFromContext: context).

	^ chatEndpoint resultFrom: requestResponse context: context.
]
