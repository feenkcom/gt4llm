Class {
	#name : #GtLlmNewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'assistantChat',
		'contents',
		'announcer'
	],
	#category : #'Gt4Llm-Widgets'
}

{ #category : #accessing }
GtLlmNewThreadMessage >> actions [
	^ assistantChat actions
]

{ #category : #accessing }
GtLlmNewThreadMessage >> annotations [
	^ {} asDictionary
]

{ #category : #accessing }
GtLlmNewThreadMessage >> assistantChat: anAssistantChat [
	assistantChat := anAssistantChat
]

{ #category : #accessing }
GtLlmNewThreadMessage >> codeBlocks [
	^ self parse children select: [ :aNode | aNode isKindOf: LeCodeBlockNode ]
]

{ #category : #accessing }
GtLlmNewThreadMessage >> codeBlocksExecutor [
	^ GtOpenAICodeBlocksPipelineExecutor new
		codeBlocks: self codeBlocks;
		pipeline: assistantChat pipeline;
		threadMessage: self
]

{ #category : #accessing }
GtLlmNewThreadMessage >> contentText [
	^ self contents
]

{ #category : #accessing }
GtLlmNewThreadMessage >> contents [
	^ contents
]

{ #category : #accessing }
GtLlmNewThreadMessage >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtLlmNewThreadMessage >> contents: aString requester: aRequester [
	contents := aString.
	self onContentsChangeByRequester: aRequester
]

{ #category : #accessing }
GtLlmNewThreadMessage >> elementClass [
	^ GtLlmNewThreadMessageElement
]

{ #category : #accessing }
GtLlmNewThreadMessage >> id [
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
GtLlmNewThreadMessage >> initialize [
	super initialize.
	contents := ''.
	announcer := Announcer new.
]

{ #category : #accessing }
GtLlmNewThreadMessage >> isAssistantRole [
	^ false
]

{ #category : #accessing }
GtLlmNewThreadMessage >> messageActions [
	^ assistantChat threadActions
]

{ #category : #'private - notifying' }
GtLlmNewThreadMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (GtOpenAINewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
]

{ #category : #accessing }
GtLlmNewThreadMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #actions }
GtLlmNewThreadMessage >> sendMessage [
	| aMessage |
	contents ifNil: [ ^ self ].
	contents ifEmpty: [ ^ self ].

	aMessage := contents.

	self contents: '' requester: nil.

	(assistantChat whenReadyFuture then: [ assistantChat sendMessage: aMessage ])
		await
]

{ #category : #subscriptions }
GtLlmNewThreadMessage >> unsubscribe: anObject [
	^ announcer unsubscribe: anObject
]

{ #category : #subscriptions }
GtLlmNewThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
]
