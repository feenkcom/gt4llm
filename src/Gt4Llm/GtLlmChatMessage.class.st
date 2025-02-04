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
	^ self contentJson at: 'Action'
]

{ #category : #accessing }
GtLlmChatMessage >> annotations [
	^ {}
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
GtLlmChatMessage >> codeBlocks [
	^ self parse children select: [ :aNode | aNode isKindOf: LeCodeBlockNode ]
]

{ #category : #accessing }
GtLlmChatMessage >> codeBlocksExecutor [
	^ chat context
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

{ #category : #accessing }
GtLlmChatMessage >> gtActionInspectFor: anAction [
	<gtLlmAction>
	^ super gtActionInspectFor: anAction
]

{ #category : #accessing }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 1;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: (GtLlmThreadMessageViewModel new threadMessage: self) ]
]

{ #category : #'as yet unclassified' }
GtLlmChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmMessageView>
	[ STONJSON fromString: self content ] on: Error do: [ ^ aView empty ].

	^ aView textEditor
		title: 'JSON';
		priority: 1;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect parsed JSON'
			action: [ :aButton | aButton phlow spawnObject: self contentJson ];
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ JSONParser gtStyler ];
		text: [ STONJSON toStringPretty: (STONJSON fromString: self content) ]
]

{ #category : #accessing }
GtLlmChatMessage >> gtToLlmActionFor: anAction [
	<gtLlmAction>
	^ anAction button
		label: 'To LLM action';
		priority: 1;
		action: [ :aButton | aButton phlow spawnObject: (GtLlmTutorAction new format: self contentText) ]
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

{ #category : #accessing }
GtLlmChatMessage >> isSystemRole [
	^ self role = 'system'
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
