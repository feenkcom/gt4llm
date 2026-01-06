Class {
	#name : #GtLOpenAIThread,
	#superclass : #GtLEntity,
	#instVars : [
		'id',
		'createdAt',
		'metadata',
		'messages',
		'tools',
		'toolResources'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIThread class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#metadata -> #metadata.
		#tools -> #tools.
		#tool_resources -> #toolResources}
]

{ #category : #accessing }
GtLOpenAIThread >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIThread >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #'gt - extensions' }
GtLOpenAIThread >> gtMessagesFor: aView [
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

{ #category : #'gt - extensions' }
GtLOpenAIThread >> gtWriteFor: aView [
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
GtLOpenAIThread >> id [
	^ id
]

{ #category : #accessing }
GtLOpenAIThread >> id: anObject [
	id := anObject
]

{ #category : #accessing }
GtLOpenAIThread >> messages [
	^ messages ifNil: [ self updateMessages ]
]

{ #category : #accessing }
GtLOpenAIThread >> metadata [
	^ metadata
]

{ #category : #accessing }
GtLOpenAIThread >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
GtLOpenAIThread >> sendMessage: aString [
	| aMessage |
	aMessage := GtLlmUserMessage new content: aString.

	self client addMessage: aMessage toThread: self id
]

{ #category : #accessing }
GtLOpenAIThread >> toolResources [
	^ toolResources
]

{ #category : #accessing }
GtLOpenAIThread >> toolResources: anObject [
	toolResources := anObject
]

{ #category : #accessing }
GtLOpenAIThread >> tools [
	^ tools
]

{ #category : #accessing }
GtLOpenAIThread >> tools: anObject [
	tools := anObject
]

{ #category : #accessing }
GtLOpenAIThread >> updateMessages [
	^ messages := self client listMessagesForThread: self id
]
