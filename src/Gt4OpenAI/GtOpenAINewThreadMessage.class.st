Class {
	#name : #GtOpenAINewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'assistantChat',
		'contents',
		'announcer'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
GtOpenAINewThreadMessage >> annotations [
	^ {} asDictionary
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> assistantChat: anAssistantChat [
	assistantChat := anAssistantChat
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> codeBlockChecker [
	^ GtOpenAICodeBlocksChecker new
		chat: assistantChat;
		maximumMessageSize: self maximumMessageSize
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> contents [
	^ contents
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> contents: aString requester: aRequester [
	contents := aString.
	self onContentsChangeByRequester: aRequester
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> elementClass [
	^ GtOpenAINewThreadMessageElement
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> id [
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
GtOpenAINewThreadMessage >> initialize [
	super initialize.
	contents := ''.
	announcer := Announcer new.
]

{ #category : #accessing }
GtOpenAINewThreadMessage >> maximumMessageSize [
	^ 30000
]

{ #category : #'private - notifying' }
GtOpenAINewThreadMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (GtOpenAINewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
]

{ #category : #actions }
GtOpenAINewThreadMessage >> sendMessage [
	contents ifNil: [ ^ self ].
	contents ifEmpty: [ ^ self ].
	assistantChat sendMessage: contents.
	self contents: '' requester: nil
]

{ #category : #subscriptions }
GtOpenAINewThreadMessage >> unsubscribe: anObject [
	^ announcer unsubscribe: anObject
]

{ #category : #subscriptions }
GtOpenAINewThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
]
