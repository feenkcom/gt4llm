Class {
	#name : #GtLlmFineTuningFile,
	#superclass : #Object,
	#instVars : [
		'conversations'
	],
	#category : #'Gt4Llm-Fine Tuning'
}

{ #category : #accessing }
GtLlmFineTuningFile >> addConversation: aConversation [
	conversations add: aConversation
]

{ #category : #accessing }
GtLlmFineTuningFile >> asJson [
	^ Character enter
		join: (self serialize collect: [ :aDict | STONJSON toString: aDict ])
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
GtLlmFineTuningFile >> gtasJsonlFor: aView [
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
	
	conversations := OrderedCollection new
]

{ #category : #accessing }
GtLlmFineTuningFile >> serialize [
	^ conversations collect: #serialize
]
