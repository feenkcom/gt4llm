"
Summarizes tool messages by grouping them by tool type.
"
Class {
	#name : #GtLToolMessagesByTypeSummarizer,
	#superclass : #GtLMessageSummarizer,
	#instVars : [
		'relevantMessages'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLToolMessagesByTypeSummarizer >> groupedMessages [
	^ self relevantMessages groupedBy: [ :each | each toolCall tool ]
]

{ #category : #'gt views' }
GtLToolMessagesByTypeSummarizer >> gtGroupedToolsFor: aView [
	<gtView>
	<gtLlmMessageView>
	
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Grouped tool messages';
		priority: 20;
		items: [ self groupedMessages associations ];
		column: 'Tool' text: [ :each | each key name ] width: 150;
		column: 'Calls' text: [ :each | each value size ] width: 100;
		column: 'Details' text: [ :each | ', ' join: (each value collect: [:m | m toolCall argumentsDisplayString ]) ];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		send: [ :each | each value ];
		actionUpdateButton
]

{ #category : #testing }
GtLToolMessagesByTypeSummarizer >> hasSummaryData [
	^ self groupedMessages isNotEmpty
]

{ #category : #initialization }
GtLToolMessagesByTypeSummarizer >> initialize [
	super initialize.
	relevantMessages := GtLMessagesGroup new
]

{ #category : #initialization }
GtLToolMessagesByTypeSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantMessages := self messagesSelect: [ :each | each isToolMessage ]
]

{ #category : #accessing }
GtLToolMessagesByTypeSummarizer >> relevantMessages [
	^ relevantMessages ifNil: [ GtLMessagesGroup new ]
]

{ #category : #accessing }
GtLToolMessagesByTypeSummarizer >> summaryText [
	^ self hasSummaryData
		ifTrue: [ '{1} tool types, {2} tool messages' format: { self groupedMessages size. self relevantMessages size } ]
		ifFalse: [ 'No tool messages' ]
]

{ #category : #accessing }
GtLToolMessagesByTypeSummarizer >> title [
	^ 'Tool messages by type'
]
