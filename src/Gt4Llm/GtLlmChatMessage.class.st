Class {
	#name : #GtLlmChatMessage,
	#superclass : #GtLlmEntity,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'content',
		'role',
		'id',
		'createdAt',
		'chat',
		'attachments',
		'announcer'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmChatMessage class >> defaultRole [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtLlmChatMessage class >> from: aDictionary [
	| aRole aContent roleClass |
	self isAbstract ifFalse: [ ^ self new from: aDictionary ].

	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	roleClass := self rolesToClasses at: aRole ifAbsent: [ self ].

	^ roleClass new from: aDictionary
]

{ #category : #'instance creation' }
GtLlmChatMessage class >> rolesToClasses [
	^ {('tool' -> GtLlmToolMessage).
	('assistant' -> GtLlmAssistantMessage).
	('user' -> GtLlmUserMessage).
	('system' -> GtLlmSystemMessage)} asDictionary
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

{ #category : #announcer }
GtLlmChatMessage >> announcer [
	<return: #Announcer>
	^ announcer ifNil: [announcer := Announcer new]
]

{ #category : #accessing }
GtLlmChatMessage >> asTokenizableString [
	^ '<|im_start|>' , self role , '<|im_sep|>' , self content , '<|im_end|>'
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
	content := anObject.
	
	self announce: GtLlmMessageContentsUpdated new
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
GtLlmChatMessage >> hasResponse [
	^ true
]

{ #category : #accessing }
GtLlmChatMessage >> id [
	^ id
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> id: anId [
	id := anId
]

{ #category : #accessing }
GtLlmChatMessage >> initialize [
	id := self uuidClass new.
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
GtLlmChatMessage >> isRawMessage [
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
	self isToolRole ifTrue: [ ^ 'Tool' ].
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
