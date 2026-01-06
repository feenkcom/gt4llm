Class {
	#name : #GtLNewMessage,
	#superclass : #GtLBasicMessage,
	#instVars : [
		'contents',
		'announcer',
		'files',
		'future',
		'isSync',
		'chat'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #accessing }
GtLNewMessage >> actions [
	^ chat assistant actions
]

{ #category : #'as yet unclassified' }
GtLNewMessage >> addFile: aFileReference [
	files add: aFileReference
]

{ #category : #accessing }
GtLNewMessage >> annotations [
	^ {} asDictionary
]

{ #category : #accessing }
GtLNewMessage >> assistantChat [
	"self deprecated: 'Use chat instead' transformWith: '`@rcv assistantChat' -> '`@rcv chat'."
	^ chat
]

{ #category : #accessing }
GtLNewMessage >> assistantChat: anAssistantChat [
	"self deprecated: 'Use #chat: instead.' transformWith: '`@rcv assistantChat: `@arg' -> '`@rcv chat: `@arg'.
"
	chat := anAssistantChat
]

{ #category : #'as yet unclassified' }
GtLNewMessage >> beSync [
	isSync := true
]

{ #category : #accessing }
GtLNewMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLNewMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLNewMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLNewMessage >> contentText [
	^ self contents
]

{ #category : #accessing }
GtLNewMessage >> contents [
	^ contents
]

{ #category : #accessing }
GtLNewMessage >> contents: anObject [
	contents := anObject
]

{ #category : #accessing }
GtLNewMessage >> contents: aString requester: aRequester [
	contents := aString.
	self onContentsChangeByRequester: aRequester
]

{ #category : #'as yet unclassified' }
GtLNewMessage >> files [
	^ files
]

{ #category : #'as yet unclassified' }
GtLNewMessage >> future [
	^ future
]

{ #category : #ui }
GtLNewMessage >> gtLiveFor: aView [
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
GtLNewMessage >> id [
	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
GtLNewMessage >> initialize [
	super initialize.
	contents := ''.
	announcer := Announcer new.
	files := OrderedCollection new.
	isSync := false.
]

{ #category : #accessing }
GtLNewMessage >> isAssistantRole [
	^ false
]

{ #category : #'private - notifying' }
GtLNewMessage >> onContentsChangeByRequester: aRequester [
	announcer
		announce: (GtLlmNewThreadMessageContentsChanged new
				threadMessage: self;
				contents: contents;
				requester: aRequester)
]

{ #category : #actions }
GtLNewMessage >> sendMessage [
	| aMessageContent aBlock |
	contents ifNil: [ ^ self ].

	aMessageContent := self treatString.

	self contents: '' requester: nil.

	self files
		ifEmpty: [ aBlock := [ chat sendPlainMessage: aMessageContent ] ]
		ifNotEmpty: [ chat sendFiles: files withMessage: aMessageContent ].

	files := OrderedCollection new.

	isSync
		ifTrue: [ aBlock value ]
		ifFalse: [ future := aBlock asAsyncPromise
					then: [  ]
					otherwise: [ :anError | anError inspect ] ]
]

{ #category : #actions }
GtLNewMessage >> treatString [
	^ contents
]

{ #category : #subscriptions }
GtLNewMessage >> unsubscribe: anObject [
	^ announcer unsubscribe: anObject
]

{ #category : #'api - converting' }
GtLNewMessage >> viewModelClass [
	^ GtLNewMessageViewModel
]

{ #category : #subscriptions }
GtLNewMessage >> when: anEventSelector send: aMessageSelector to: anObject [
	^ announcer weak
		when: anEventSelector
		send: aMessageSelector
		to: anObject
]
