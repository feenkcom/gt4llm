Class {
	#name : #GtLlmNewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'assistantChat',
		'contents',
		'announcer',
		'files',
		'future',
		'isSync'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmNewThreadMessage >> actions [
	^ assistantChat assistant actions
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

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessage >> beSync [
	isSync := true
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

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessage >> files [
	^ files
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessage >> future [
	^ future
]

{ #category : #'as yet unclassified' }
GtLlmNewThreadMessage >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 1;
		stencil: [ self asViewModel asElement
				margin: (BlInsets all: 10);
				background: Color white;
				addAptitude: BrShadowAptitude new ]
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
	files := OrderedCollection new.
	isSync := false.
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

{ #category : #actions }
GtLlmNewThreadMessage >> sendMessage [
	| aMessageContent aBlock |
	contents ifNil: [ ^ self ].

	aMessageContent := self treatString.

	self contents: '' requester: nil.

	self files
		ifEmpty: [ aBlock := [ assistantChat sendMessage: aMessageContent ] ]
		ifNotEmpty: [ assistantChat sendFiles: files withMessage: aMessageContent ].
		
	files := OrderedCollection new.

	isSync ifTrue: [ aBlock value ] ifFalse: [ future := aBlock asAsyncPromise ]
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
