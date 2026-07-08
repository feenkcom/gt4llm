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

{ #category : #testing }
GtLToolCallsByTypeSummarizer class >> isActive [ 
	^true
]

{ #category : #private }
GtLToolCallsByTypeSummarizer >> durationTextFor: aDuration [
	^ aDuration
		ifNil: [ '' ]
		ifNotNil: [ :theDuration |
			theDuration gtPreciseHumanReadableString ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> groupedToolCalls [
	^ ((self relevantToolCalls 
			groupedBy: [ :each | each tool ]) associations
				collect: [ :assoc |
					assoc key -> (GtLFunctionToolCallsGroup withAll: assoc value ) ])
			 asDictionary
]

{ #category : #'gt-extensions' }
GtLToolCallsByTypeSummarizer >> gtGroupedToolsDetailedGroupingFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Grouped tools (detailed)';
		priority: 25;
		items: [ self groupedToolCalls associations
			sorted: [ :each | each value size ] descending ];
		column: 'Tool' text: [ :assoc | assoc key name ];
		column: 'Count' text: [ :assoc | assoc value size ] width: 100;
		column: 'Total duration' text: [ :assoc | 
			self durationTextFor: assoc value totalExecutionDuration ];
		column: 'GC duration' text: [ :assoc | 
			self durationTextFor: assoc value totalGcExecutionDuration ];
		column: 'Aveage duration' text: [ :assoc | 
			self durationTextFor: assoc value averageExecutionDuration ];
		column: 'Longest run' text: [ :assoc | 
			self durationTextFor: assoc value longestExecutionDuration ];
		column: 'Last call duration' text: [ :assoc | 
			self durationTextFor: assoc value lastExecutionDuration ];
		send: [ :assoc | assoc value ];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		actionUpdateButton
]

{ #category : #'gt-extensions' }
GtLToolCallsByTypeSummarizer >> gtGroupedToolsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Grouped tools';
		priority: 21;
		items: [ self groupedToolCalls associations
			sorted: [ :each | each value size ] descending ];
		column: 'Tool' text: [ :assoc | assoc key name ];
		column: 'Count' text: [ :assoc | assoc value size ] width: 100;
		column: 'Total duration' text: [ :assoc | 
			self durationTextFor: assoc value totalExecutionDuration ];
		column: 'Aveage duration' text: [ :assoc | 
			self durationTextFor: assoc value averageExecutionDuration ];
		column: 'Longest run' text: [ :assoc | 
			self durationTextFor: assoc value longestExecutionDuration ];
		send: [ :assoc | assoc value ];
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
		ifTrue: [ '{1} tool types, {2} tool calls, {3} total duration' format: { 
			self groupedToolCalls size. 
			self relevantToolCalls size.
			(self durationTextFor: self totalExecutionDuration) } ]
		ifFalse: [ 'No tool calls' ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> title [
	^ 'Tool calls by type'
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> totalExecutionDuration [
	^ self relevantToolCalls
		inject: 0 seconds 
		into: [ :total  :each | 
			total + (each totalExecutionDuration 
				ifNil: [ 0 seconds ]) ]
]

{ #category : #accessing }
GtLToolCallsByTypeSummarizer >> totalGcExecutionDuration [
	^ self relevantToolCalls
		inject: 0 seconds 
		into: [ :total  :each | 
			total + (each totalGcExecutionDuration 
				ifNil: [ 0 seconds ]) ]
]
