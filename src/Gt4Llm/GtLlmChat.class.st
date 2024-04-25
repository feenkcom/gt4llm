Class {
	#name : #GtLlmChat,
	#superclass : #Object,
	#instVars : [
		'client',
		'messages',
		'model',
		'lastUpdated'
	],
	#category : #'Gt4Llm-Chats'
}

{ #category : #accessing }
GtLlmChat >> addMessage: aMessage [
	self updateLastUpdated.
	messages add: aMessage
]

{ #category : #accessing }
GtLlmChat >> client [
	^ client
]

{ #category : #accessing }
GtLlmChat >> client: anObject [
	client := anObject
]

{ #category : #accessing }
GtLlmChat >> gtMessagesFor: aView [
	<gtView>
	^ aView forward
		title: 'Messages';
		priority: 1;
		object: [ self messages ];
		view: #gtMessagesFor:
]

{ #category : #accessing }
GtLlmChat >> gtWriteFor: aView [
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
GtLlmChat >> initialize [
	super initialize.
	
	self initializeClient.
	self initializeMessages.
	
	self updateLastUpdated
]

{ #category : #accessing }
GtLlmChat >> initializeClient [
	self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> initializeMessages [
	self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> lastUpdated [
	^ lastUpdated
]

{ #category : #accessing }
GtLlmChat >> lastUpdated: anObject [
	lastUpdated := anObject
]

{ #category : #accessing }
GtLlmChat >> messages [
	^ messages
]

{ #category : #accessing }
GtLlmChat >> messages: anObject [
	messages := anObject
]

{ #category : #accessing }
GtLlmChat >> model [
	^ model
]

{ #category : #accessing }
GtLlmChat >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmChat >> sendMessage: aMessage [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLlmChat >> updateLastUpdated [
	lastUpdated := DateAndTime now
]
