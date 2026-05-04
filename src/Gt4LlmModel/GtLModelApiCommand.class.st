Class {
	#name : #GtLModelApiCommand,
	#superclass : #GtLAPICommand,
	#instVars : [
		'model'
	],
	#category : #'Gt4LlmModel-Core'
}

{ #category : #accessing }
GtLModelApiCommand >> model [
	^ model
]

{ #category : #accessing }
GtLModelApiCommand >> model: anObject [
	model := anObject
]

{ #category : #'as yet unclassified' }
GtLModelApiCommand >> perform [
	| requestResponse chatEndpoint context |
	
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
