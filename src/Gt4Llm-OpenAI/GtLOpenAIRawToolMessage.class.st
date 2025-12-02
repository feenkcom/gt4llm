Class {
	#name : #GtLOpenAIRawToolMessage,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'chat',
		'createdAt',
		'toolCall',
		'reasoning'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> action [
	^ 'Tool call(' , self toolCall humanReadable , ')'
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> actionModel [
	^ self toolCall
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> chat [
	^ chat
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> chat: anObject [
	chat := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> content [
	^ rawData
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> contentText [
	^ STONJSON toString: rawData
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> createdAt [
	^ createdAt
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> createdAt: anObject [
	createdAt := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> gtViewRawDataFor: aView [
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
GtLOpenAIRawToolMessage >> id [
	^ rawData at: 'id' ifAbsent: ''
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> initialize [
	super initialize.

	createdAt := DateAndTime now
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> isAssistantRole [
	^ false
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> isRawMessage [
	^ true
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> isToolRole [
	^ true
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> rawData [
	^ rawData
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> rawData: anObject [
	rawData := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> reasoning [
	^ reasoning
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> reasoning: anObject [
	reasoning := anObject
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> role [
	^ 'raw'
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> senderText [
	^ 'Assistant'
]

{ #category : #'as yet unclassified' }
GtLOpenAIRawToolMessage >> serialize [
	^ rawData
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLOpenAIRawToolMessage >> toolCall: anObject [
	toolCall := anObject
]
