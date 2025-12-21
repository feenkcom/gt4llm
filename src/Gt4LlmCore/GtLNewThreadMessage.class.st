Class {
	#name : #GtLNewThreadMessage,
	#superclass : #Object,
	#instVars : [
		'contents',
		'announcer',
		'files',
		'future',
		'isSync',
		'chat'
	],
	#category : #'Gt4LlmCore-UI'
}

{ #category : #accessing }
GtLNewThreadMessage >> actions [
	^ chat assistant actions
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessage >> addFile: aFileReference [
	files add: aFileReference
]

{ #category : #accessing }
GtLNewThreadMessage >> annotations [
	^ {} asDictionary
]

{ #category : #ui }
GtLNewThreadMessage >> asViewModel [
	^ GtLlmNewThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtLNewThreadMessage >> assistantChat [
	"self deprecated: 'Use chat instead' transformWith: '`@rcv assistantChat' -> '`@rcv chat'."
	^ chat
]

{ #category : #accessing }
GtLNewThreadMessage >> assistantChat: anAssistantChat [
	"self deprecated: 'Use #chat: instead.' transformWith: '`@rcv assistantChat: `@arg' -> '`@rcv chat: `@arg'.
"
	chat := anAssistantChat
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessage >> beSync [
	isSync := true
]

{ #category : #accessing }
GtLNewThreadMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLNewThreadMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLNewThreadMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLNewThreadMessage >> contentText [
	^ self contents
]

{ #category : #accessing }
GtLNewThreadMessage >> contents [
	^ contents
]

{ #category : #accessing }
GtLNewThreadMessage >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtLNewThreadMessage >> contents: aString requester: aRequester [
	contents := aString.
	self onContentsChangeByRequester: aRequester
]

{ #category : #ui }
GtLNewThreadMessage >> elementClass [
	^ GtLlmNewThreadMessageElement
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessage >> files [
	^ files
]

{ #category : #'as yet unclassified' }
GtLNewThreadMessage >> future [
	^ future
]

{ #category : #ui }
GtLNewThreadMessage >> gtLiveFor: aView [
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
GtLNewThreadMessage >> id [
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
GtLNewThreadMessage >> initialize [
	super initialize.
	contents := ''.
	announcer := Announcer new.
	files := OrderedCollection new.
	isSync := false.
]

{ #category : #accessing }
GtLNewThreadMessage >> isAssistantRole [
	^ false
]

{ #category : #'private - notifying' }
GtLNewThreadMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (GtLlmNewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
]

{ #category : #actions }
GtLNewThreadMessage >> sendMessage [
	| aMessageContent aBlock |
	contents ifNil: [ ^ self ].

	aMessageContent := self treatString.

	self contents: '' requester: nil.

	self files
		ifEmpty: [ aBlock := [ chat sendMessage: aMessageContent ] ]
		ifNotEmpty: [ chat sendFiles: files withMessage: aMessageContent ].

	files := OrderedCollection new.

	isSync
		ifTrue: [ aBlock value ]
		ifFalse: [ future := aBlock asAsyncPromise
					then: [  ]
					otherwise: [ :anError | anError inspect ] ]
]

{ #category : #actions }
GtLNewThreadMessage >> treatString [
	^ contents
]

{ #category : #subscriptions }
GtLNewThreadMessage >> unsubscribe: anObject [
	^ announcer unsubscribe: anObject
]

{ #category : #subscriptions }
GtLNewThreadMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
]
