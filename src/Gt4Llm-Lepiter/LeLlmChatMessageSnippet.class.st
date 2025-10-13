Class {
	#name : #LeLlmChatMessageSnippet,
	#superclass : #LeLlmSnippet,
	#instVars : [
		'messageId'
	],
	#category : #'Gt4Llm-Lepiter-Model'
}

{ #category : #accessing }
LeLlmChatMessageSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#messageId -> #messageId);
		yourself
]

{ #category : #accessing }
LeLlmChatMessageSnippet class >> leJsonV4Name [

	^ #llmChatMessageSnippet
]

{ #category : #visiting }
LeLlmChatMessageSnippet >> acceptVisitor: aVisitor [

	^ aVisitor visitLlmChatMessageSnippet: self
]

{ #category : #converting }
LeLlmChatMessageSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>

	^ LeLlmChatMessageSnippetViewModel new snippetModel: self
]

{ #category : #accessing }
LeLlmChatMessageSnippet >> contentAsString [
	| messageText |
	
	messageText := self message contentText.
	^ self message role
		ifNil: [ messageText ]
		ifNotNil: [ :role | role asString, ': ', messageText ]
]

{ #category : #accessing }
LeLlmChatMessageSnippet >> message [

	^ self parent entityWithId: messageId
]

{ #category : #accessing }
LeLlmChatMessageSnippet >> messageId [
	^ messageId
]

{ #category : #accessing }
LeLlmChatMessageSnippet >> messageId: anObject [
	messageId := anObject
]

{ #category : #accessing }
LeLlmChatMessageSnippet >> text [

	^ self contentAsString asRopedText
]
