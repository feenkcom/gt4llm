Class {
	#name : #GtOpenAIThread,
	#superclass : #GtLlmEntity,
	#instVars : [
		'id',
		'createdAt',
		'metadata',
		'messages',
		'tools',
		'toolResources'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIThread class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#metadata -> #metadata.
		#tools -> #tools.
		#tool_resources -> #toolResources}
]

{ #category : #accessing }
GtOpenAIThread >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIThread >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
GtOpenAIThread >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ self messages ];
		view: #gtMessagesFor:;
		actionButtonIcon: BrGlamorousVectorIcons refresh
			tooltip: 'Update'
			action: [ :aButton :aTab | 
				self updateMessages.
				aTab viewContentElement phlow update ]
]

{ #category : #accessing }
GtOpenAIThread >> gtWriteFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Write';
		priority: 2;
		text: [ 'Write a message here' ];
		actionButtonIcon: BrGlamorousVectorIcons play
			tooltip: 'Send'
			action: [ :aButton | 
				aButton parent parent parent parent
					allChildrenBreadthFirstDetect: [ :anElement | anElement isKindOf: BrEditor ]
					ifFound: [ :anEditor | 
						self sendMessage: anEditor text asString.
						anEditor text: '' ] ]
]

{ #category : #accessing }
GtOpenAIThread >> id [
	^ id
]

{ #category : #accessing }
GtOpenAIThread >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtOpenAIThread >> messages [
	^ messages ifNil: [ self updateMessages ]
]

{ #category : #accessing }
GtOpenAIThread >> metadata [
	^ metadata
]

{ #category : #accessing }
GtOpenAIThread >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtOpenAIThread >> sendMessage: aString [
	| aMessage |
	aMessage := GtLlmUserMessage new content: aString.

	self client addMessage: aMessage toThread: self id
]

{ #category : #accessing }
GtOpenAIThread >> toolResources [
	^ toolResources
]

{ #category : #accessing }
GtOpenAIThread >> toolResources: anObject [
	toolResources := anObject
]

{ #category : #accessing }
GtOpenAIThread >> tools [
	^ tools
]

{ #category : #accessing }
GtOpenAIThread >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtOpenAIThread >> updateMessages [
	^ messages := self client listMessagesForThread: self id
]
