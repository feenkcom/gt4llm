Class {
	#name : #GtOpenAIRawToolMessage,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'chat',
		'createdAt',
		'toolCall',
		'reasoning'
	],
	#category : #Gt4OpenAI
}

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> action [
	^ 'Tool call(' , self toolCall humanReadable , ')'
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> actionModel [
	^ self toolCall
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> content [
	^ rawData
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> contentText [
	^ STONJSON toString: rawData
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> gtViewRawDataFor: aView [
	<gtView>
	<gtLlmMessageView>
	self rawData ifNil: [^ aView empty ].

	^ aView forward
		title: 'Raw data';
		priority: 10;
		object: [ self rawData ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> id [
	^ rawData at: 'id' ifAbsent: ''
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> initialize [
	super initialize.

	createdAt := DateAndTime now
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> isAssistantRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> isRawMessage [
	^ true
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> isToolRole [
	^ true
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> reasoning [
	^ reasoning
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> reasoning: anObject [
	reasoning := anObject
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> role [
	^ 'raw'
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> senderText [
	^ 'Assistant'
]

{ #category : #'as yet unclassified' }
GtOpenAIRawToolMessage >> serialize [
	^ rawData
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtOpenAIRawToolMessage >> toolCall: anObject [
	toolCall := anObject
]
