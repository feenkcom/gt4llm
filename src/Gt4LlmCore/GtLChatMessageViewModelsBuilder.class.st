"
I am responsible for composing view model messages.
I group tool messages and put them as a part of an assistant message.
"
Class {
	#name : #GtLChatMessageViewModelsBuilder,
	#superclass : #Object,
	#instVars : [
		'cache',
		'chat',
		'messages',
		'stream',
		'lastMessage',
		'newMessageViewModel',
		'status'
	],
	#category : 'Gt4LlmCore-Support'
}

{ #category : #'api - building' }
GtLChatMessageViewModelsBuilder >> build [
	self assert: [ chat isNotNil ].
	self assert: [ cache isNotNil ].
	messages := chat messages.
	lastMessage := messages size > 0 ifTrue: [ messages last ] ifFalse: [ nil ].
	status := chat state.

	^ Array
		new: messages size
		streamContents: [ :aStream | 
			stream := aStream.
			self buildMessages.
			self buildNewMessage.
			stream := nil ]
]

{ #category : #'private - building' }
GtLChatMessageViewModelsBuilder >> buildMessages [
	"I group tool message into corresponding assistant messages."

	| previousUserViewMessage previousToolViewMessages |
	previousUserViewMessage := nil.
	previousToolViewMessages := OrderedCollection new.

	messages
		do: [ :aMessage | 
			| aViewModel |
			aViewModel := self viewModelFor: aMessage.
			
			aMessage isUserRole ifTrue: [
				stream nextPutAll: previousToolViewMessages.
				stream nextPut: aViewModel.
				previousUserViewMessage := aViewModel.
				previousToolViewMessages := OrderedCollection new ].
			
			(aMessage isToolRole and: [ aMessage isReplyMessage not ]) ifTrue: [
				previousToolViewMessages add: aViewModel ].
			
			(aMessage isReplyMessage) ifTrue: [ 
				stream nextPut: aViewModel.
				aViewModel userViewMessage: previousUserViewMessage.
				aViewModel toolViewMessages: previousToolViewMessages.
				previousUserViewMessage := nil.
				previousToolViewMessages := OrderedCollection new ] 
		].
		
	stream nextPutAll: previousToolViewMessages.
]

{ #category : #'private - building' }
GtLChatMessageViewModelsBuilder >> buildNewMessage [
	newMessageViewModel ifNil: [ ^ self ].

	stream nextPut: newMessageViewModel
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> cache [
	^ cache
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> cache: anObject [
	cache := anObject
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> newMessageViewModel [
	^ newMessageViewModel
]

{ #category : #accessing }
GtLChatMessageViewModelsBuilder >> newMessageViewModel: anObject [
	newMessageViewModel := anObject
]

{ #category : #'private - building' }
GtLChatMessageViewModelsBuilder >> viewModelFor: aMessage [
	^ cache
		at: aMessage id
		ifPresent: [ :theViewModel | 
			theViewModel message: aMessage.
			lastMessage = aMessage ifTrue: [
				theViewModel isExpanded: (theViewModel isExpanded or: [ aMessage isAssistantRole ]) ].
			theViewModel ]
		ifAbsentPut: [ aMessage asViewModel
				isExpanded: (lastMessage = aMessage and: [ aMessage isAssistantRole ]) ]
]
