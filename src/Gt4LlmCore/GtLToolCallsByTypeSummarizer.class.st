"
Summarizes tool calls by grouping them by tool type.
"
Class {
	#name : #GtLToolCallsByTypeSummarizer,
	#superclass : #GtLToolCallsSummarizer,
	#instVars : [
		'relevantToolCalls'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> groupedToolCalls [
	^ self relevantToolCalls groupedBy: [ :each | each tool ]
]

{ #category : #'gt-extensions' }
GtLToolCallsByTypeSummarizer >> gtGroupedToolsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Grouped tool calls';
		priority: 10;
		items: [ self groupedToolCalls associations ];
		column: 'Tool' text: [ :each | each key name ];
		column: 'Count' text: [ :each | each value size ] width: 100;
		send: [ :each | each value ];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		actionUpdateButton
]

{ #category : #initialization }
GtLToolCallsByTypeSummarizer >> initialize [
	super initialize.
	relevantToolCalls := OrderedCollection new
]

{ #category : #initialization }
GtLToolCallsByTypeSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantToolCalls := self toolCallsSelect: [ :each | true ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> relevantToolCalls [
	^ relevantToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> summaryText [
	^ self hasSummaryData
		ifTrue: [ '{1} tool types, {2} tool calls' format: { self groupedToolCalls size. self relevantToolCalls size } ]
		ifFalse: [ 'No tool calls' ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> title [
	^ 'Tool calls by type'
]
