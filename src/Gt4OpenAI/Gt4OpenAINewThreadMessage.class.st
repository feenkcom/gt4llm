Class {
	#name : #Gt4OpenAINewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'assistantChat',
		'contents',
		'announcer'
	],
	#category : #'Gt4OpenAI-Widgets'
}

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> assistantChat: anAssistantChat [
	assistantChat := anAssistantChat
]

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> contents [
	^ contents
]

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> contents: aString requester: aRequester [
	contents := aString.
	self onContentsChangeByRequester: aRequester
]

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> elementClass [
	^ Gt4OpenAINewThreadMessageElement
]

{ #category : #accessing }
Gt4OpenAINewThreadMessage >> id [
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
Gt4OpenAINewThreadMessage >> initialize [
	super initialize.
	contents := ''.
	announcer := Announcer new.
]

{ #category : #'private - notifying' }
Gt4OpenAINewThreadMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (Gt4OpenAINewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
]

{ #category : #actions }
Gt4OpenAINewThreadMessage >> sendMessage [
	contents ifNil: [ ^ self ].
	contents ifEmpty: [ ^ self ].
	assistantChat sendMessage: contents.
	self contents: '' requester: nil
]

{ #category : #subscriptions }
Gt4OpenAINewThreadMessage >> unsubscribe: anObject [
	^ announcer unsubscribe: anObject
]

{ #category : #subscriptions }
Gt4OpenAINewThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
]
