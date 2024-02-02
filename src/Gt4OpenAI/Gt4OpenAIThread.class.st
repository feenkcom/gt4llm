Class {
	#name : #Gt4OpenAIThread,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'id',
		'createdAt',
		'metadata',
		'messages'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIThread class >> serializationProperties [
	^ {#id -> #id.
		#created_at -> #createdAt.
		#metadata -> #metadata}
]

{ #category : #accessing }
Gt4OpenAIThread >> createdAt [
	^ createdAt
]

{ #category : #accessing }
Gt4OpenAIThread >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #accessing }
Gt4OpenAIThread >> gtMessagesFor: aView [
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
Gt4OpenAIThread >> gtWriteFor: aView [
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
Gt4OpenAIThread >> id [
	^ id
]

{ #category : #accessing }
Gt4OpenAIThread >> id: anObject [
	id := anObject
]

{ #category : #accessing }
Gt4OpenAIThread >> messages [
	^ messages ifNil: [ self updateMessages ]
]

{ #category : #accessing }
Gt4OpenAIThread >> metadata [
	^ metadata
]

{ #category : #accessing }
Gt4OpenAIThread >> metadata: anObject [
	metadata := anObject
]

{ #category : #accessing }
Gt4OpenAIThread >> sendMessage: aString [
	| aMessage |
	aMessage := Gt4OpenAIUserMessage new content: aString.

	self client addMessage: aMessage toThread: self id
]

{ #category : #accessing }
Gt4OpenAIThread >> updateMessages [
	^ messages := self client listMessagesForThread: self id
]
