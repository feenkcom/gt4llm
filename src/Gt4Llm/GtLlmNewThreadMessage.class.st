Class {
	#name : #GtLlmNewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'assistantChat',
		'contents',
		'announcer',
		'files'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmNewThreadMessage >> actions [
	^ assistantChat tutor actions
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessage >> addFile: aFileReference [
	files add: aFileReference
]

{ #category : #accessing }
GtLlmNewThreadMessage >> annotations [
	^ {} asDictionary
]

{ #category : #accessing }
GtLlmNewThreadMessage >> assistantChat [
	^ assistantChat
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
GtLlmNewThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
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
	files := OrderedCollection new
]

{ #category : #accessing }
GtLlmNewThreadMessage >> isAssistantRole [
	^ false
]

{ #category : #'private - notifying' }
GtLlmNewThreadMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (GtLlmNewThreadMessageContentsChanged new
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
	| aMessageContent |
	contents ifNil: [ ^ self ].
	
	"todo: add files"

	aMessageContent := self treatString.

	self contents: '' requester: nil.

	[assistantChat sendMessage: aMessageContent] asAsyncPromise
]

{ #category : #actions }
GtLlmNewThreadMessage >> treatString [
	^ contents
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
