Class {
	#name : #GtLlmChatMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'content',
		'role',
		'id',
		'createdAt',
		'chat',
		'attachments'
	],
	#category : #'Gt4Llm-Models'
}

{ #category : #accessing }
GtLlmChatMessage class >> defaultRole [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtLlmChatMessage class >> from: aDictionary [
	| aRole aContent |
	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	self
		subclassesDo: [ :aSubclass | aSubclass defaultRole = aRole ifTrue: [ ^ aSubclass new content: aContent ] ].

	^ self new from: aDictionary
]

{ #category : #accessing }
GtLlmChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> action [
	^ [ self contentJson at: 'Action' ] on: Error do: [ nil ]
]

{ #category : #accessing }
GtLlmChatMessage >> annotations [
	^ {}
]

{ #category : #accessing }
GtLlmChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #accessing }
GtLlmChatMessage >> attachments [
	^ attachments
]

{ #category : #accessing }
GtLlmChatMessage >> attachments: anObject [
	attachments := anObject
]

{ #category : #accessing }
GtLlmChatMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLlmChatMessage >> chat: anObject [
	chat := anObject
]

{ #category : #accessing }
GtLlmChatMessage >> content [
	^ content
]

{ #category : #accessing }
GtLlmChatMessage >> content: anObject [
	content := anObject
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> contentJson [
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtLlmChatMessage >> contentSummary [
	^ self contentText lines ifEmpty: [ '' ] ifNotEmpty: #first
]

{ #category : #accessing }
GtLlmChatMessage >> contentText [
	^ self content
]

{ #category : #accessing }
GtLlmChatMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLlmChatMessage >> createdAt: anObject [
	createdAt := self deserializeTime: anObject
]

{ #category : #accessing }
GtLlmChatMessage >> descendant [
	^ self chat descendantOf: self
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> gtActionInspectFor: anAction [
	<gtAction>
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
]

{ #category : #accessing }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: self asViewModel ]
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> gtJsonFor: aView context: aContext [
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView context: aContext)
		title: 'JSON data';
		priority: 4.5
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	| json |
	[ json := self contentJson ] on: Error do: [ ^ aView empty ].

	json at: 'Text' ifAbsent: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 1;
		text: [ json at: 'Text' ];
		styler: [ GtLlmMessageStyler new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtLlmChatMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLlmChatMessage >> id [
	^ id
]

{ #category : #accessing }
GtLlmChatMessage >> initialize [
	id := UUID new.
	createdAt := DateAndTime now
]

{ #category : #accessing }
GtLlmChatMessage >> isAssistantRole [
	^ self role = 'assistant'
]

{ #category : #accessing }
GtLlmChatMessage >> isFailure [
	^ false
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> isReady [
	^ true
]

{ #category : #accessing }
GtLlmChatMessage >> isSystemRole [
	^ self role = 'system'
]

{ #category : #accessing }
GtLlmChatMessage >> isToolRole [
	^ self role = 'tool'
]

{ #category : #accessing }
GtLlmChatMessage >> isUserRole [
	^ self role = 'user'
]

{ #category : #accessing }
GtLlmChatMessage >> parse [
	^ LeParser parse: self contentText
]

{ #category : #accessing }
GtLlmChatMessage >> role [
	^ role ifNil: [ role := self class defaultRole ]
]

{ #category : #accessing }
GtLlmChatMessage >> role: anObject [
	role := anObject
]

{ #category : #accessing }
GtLlmChatMessage >> senderText [
	self isAssistantRole ifTrue: [ ^ 'Assistant' ].
	self isSystemRole ifTrue: [ ^ 'System' ].
	^ 'You'
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> serialize [
	| serialized |
	serialized := super serialize.

	self attachments
		ifNotNil: [ serialized
				at: 'attachments'
				put: (self attachments
						collect: [ :aFile | 
							{'file_id' -> aFile remoteId.
								'tools' -> {{'type' -> 'file_search'} asDictionary}} asDictionary ]) ].

	^ serialized
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> serializeInline [
]
