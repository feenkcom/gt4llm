Class {
	#name : #GtLlmFineTuningFile,
	#superclass : #Object,
	#instVars : [
		'conversations',
		'model'
	],
	#category : #'Gt4Llm-Fine Tuning'
}

{ #category : #accessing }
GtLlmFineTuningFile >> addConversation: aConversation [
	conversations add: aConversation
]

{ #category : #accessing }
GtLlmFineTuningFile >> asJson [
	^ Character linefeed
		join: (self serialize collect: [ :aDict | STONJSON toString: aDict ])
]

{ #category : #accessing }
GtLlmFineTuningFile >> basename [
	^ self name
]

{ #category : #accessing }
GtLlmFineTuningFile >> contents [
	^ self asJson
]

{ #category : #accessing }
GtLlmFineTuningFile >> conversations [
	^ conversations
]

{ #category : #accessing }
GtLlmFineTuningFile >> conversations: anObject [
	conversations := anObject
]

{ #category : #accessing }
GtLlmFineTuningFile >> costsPerEpoch [
	| tokens |
	tokens := self numberOfTokens.
	^ GtTCurrencyMoney new
		amount: tokens * self pricePerToken;
		currency: GtTCurrency usd
]

{ #category : #accessing }
GtLlmFineTuningFile >> defaultModel [
	^ 'gpt-3.5-turbo'
]

{ #category : #accessing }
GtLlmFineTuningFile >> gtConversationsFor: aView [
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
							collect: [ :aMessage | aMessage role , ': ' , aMessage content ]) ]
]

{ #category : #accessing }
GtLlmFineTuningFile >> gtCostFor: aView [
	<gtView>
	^ aView forward
		title: 'Cost';
		priority: 3;
		object: [ self costsPerEpoch ];
		view: #gtDetailsFor:
]

{ #category : #accessing }
GtLlmFineTuningFile >> gtJsonlFor: aView [
	<gtView>
	^ aView forward
		title: 'JSONL';
		priority: 2;
		object: [ self asJson ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GtLlmFineTuningFile >> initialize [
	super initialize.
	
	conversations := OrderedCollection new.
	model := self defaultModel
]

{ #category : #accessing }
GtLlmFineTuningFile >> model [
	^ model
]

{ #category : #accessing }
GtLlmFineTuningFile >> model: anObject [
	model := anObject
]

{ #category : #accessing }
GtLlmFineTuningFile >> name [
	^ name
]

{ #category : #accessing }
GtLlmFineTuningFile >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtLlmFineTuningFile >> numberOfTokens [
	^ (GtLlmTokenizer new
		tokenizeMessages: (conversations flatCollect: #items)
		usingModel: self model) tokenCount
]

{ #category : #accessing }
GtLlmFineTuningFile >> pricePerToken [
	^ ({'gpt-3.5-turbo' -> 8.
		'davinci-002' -> 6.
		'babbage-002' -> 0.4} asDictionary at: self model) / 1000000
]

{ #category : #accessing }
GtLlmFineTuningFile >> serialize [
	^ conversations collect: #serialize
]
