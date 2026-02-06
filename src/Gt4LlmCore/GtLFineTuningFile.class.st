Class {
	#name : #GtLFineTuningFile,
	#superclass : #Object,
	#instVars : [
		'conversations',
		'model',
		'name'
	],
	#category : 'Gt4LlmCore-FineTuning'
}

{ #category : #accessing }
GtLFineTuningFile >> addConversation: aConversation [
	conversations add: aConversation
]

{ #category : #accessing }
GtLFineTuningFile >> asJson [
	^ Character linefeed
		join: (self serialize collect: [ :aDict | STONJSON toString: aDict ])
]

{ #category : #accessing }
GtLFineTuningFile >> basename [
	^ self name
]

{ #category : #accessing }
GtLFineTuningFile >> binaryContents [
	^ self asJson asByteString
]

{ #category : #accessing }
GtLFineTuningFile >> contents [
	^ self asJson
]

{ #category : #accessing }
GtLFineTuningFile >> conversations [
	^ conversations
]

{ #category : #accessing }
GtLFineTuningFile >> conversations: anObject [
	conversations := anObject
]

{ #category : #accessing }
GtLFineTuningFile >> defaultModel [
	^ 'gpt-3.5-turbo'
]

{ #category : #accessing }
GtLFineTuningFile >> gtConversationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Conversations';
		priority: 1;
		items: [ conversations ];
		column: 'Size'
			text: #size
			width: 50;
		column: 'Messages'
			text: [ :aConversation | 
				Character enter
					join: (aConversation items
							collect: [ :aMessage | aMessage role , ': ' , aMessage contentText ]) ]
]

{ #category : #accessing }
GtLFineTuningFile >> gtJsonlFor: aView [
	<gtView>
	^ aView forward
		title: 'JSONL';
		priority: 2;
		object: [ self asJson ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLFineTuningFile >> initialize [
	super initialize.
	
	conversations := OrderedCollection new.
	model := self defaultModel
]

{ #category : #accessing }
GtLFineTuningFile >> model [
	^ model
]

{ #category : #accessing }
GtLFineTuningFile >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLFineTuningFile >> name [
	^ name
]

{ #category : #accessing }
GtLFineTuningFile >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLFineTuningFile >> pricePerToken [
	^ ({'gpt-3.5-turbo' -> 8.
		'gpt-4o-mini' -> 3.
		'davinci-002' -> 6.
		'babbage-002' -> 0.4} asDictionary
		at: ((self model beginsWith: 'gpt-4o-mini')
				ifTrue: [ 'gpt-4o-mini' ]
				ifFalse: [ self model ])) / 1000000
]

{ #category : #accessing }
GtLFineTuningFile >> serialize [
	^ conversations collect: #serialize
]
