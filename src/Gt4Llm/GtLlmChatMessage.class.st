Class {
	#name : #GtLlmChatMessage,
	#superclass : #GtLlmEntity,
	#instVars : [
		'content',
		'role',
		'id',
		'createdAt',
		'chat'
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

	^ self new
		role: aRole;
		content: aContent
]

{ #category : #accessing }
GtLlmChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
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
	createdAt := anObject
]

{ #category : #accessing }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ]
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
