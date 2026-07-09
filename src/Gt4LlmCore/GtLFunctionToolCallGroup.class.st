Class {
	#name : #GtLFunctionToolCallGroup,
	#superclass : #GtLGroup,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCallGroup >> averageExecutionDuration [
	| durations totalDuration | 
	
	durations := (self collect: [ :each | each totalExecutionDuration ])
		reject: [ :each | each isNil ].
	totalDuration := durations  
		inject: 0 seconds 
		into: [ :total  :aDuration | 
			total + aDuration ].
			
	^ totalDuration / durations size
]

{ #category : #private }
GtLFunctionToolCallGroup >> durationTextFor: aDuration [
	^ aDuration
		ifNil: [ '' ]
		ifNotNil: [ :theDuration |
			theDuration gtHumanReadableStringUpToMilliseconds ]
]

{ #category : #views }
GtLFunctionToolCallGroup >> gToolCallsSummariesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Tool call summarizers';
		priority: 30;
		items: [ self toolCallsSummarizers ];
		column: 'Summary' 
			text: [ :each | each title ];
		column: 'Details' text: [ :each | 
			each summaryText ];
		column: 'Has data' 
			text: [ :each | 
				each hasSummaryData ifTrue: [ 'yes' ] ifFalse: [ 'no' ] ]
			width: 100
]

{ #category : #views }
GtLFunctionToolCallGroup >> gtItemsFor: aView [
	<gtView>
	
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		column: 'Tool name' text: [ :each | each name ];
		column: 'Start time' text: [ :each | 
			each executionStartTime
				ifNil: [ '' ] 
				ifNotNil: [ :aDateAndTime | 
					String
						streamContents: [ :s | aDateAndTime asLocal 
							printSeparateDateAndTimeOn: s ] ] ];
		column: 'Total duration' text: [ :each | 
			self durationTextFor: each totalExecutionDuration ];
		column: 'Duration (without GC)' text: [ :each | 
			self durationTextFor: each executionDurationWithoutGc ];
		column: 'GC duration' text: [ :each | 
			self durationTextFor: each gcExecutionDuration ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> lastExecution [
	^ (self sorted: [:each | each executionEndTime ] ascending)
		ifEmpty: [ nil ] 
		ifNotEmpty: [ :each | each last ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> lastExecutionDuration [
	^ self lastExecution 
			ifNil: [ nil ] 
			ifNotNil: [ :aToolExecution |
				aToolExecution totalExecutionDuration ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> longestExecutionDuration [
	| durations | 
	
	durations := (self collect: [ :each | each totalExecutionDuration ])
		reject: [ :each | each isNil ].
	durations ifEmpty: [ ^ nil ].
	
	^ durations max
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> sumDurations: aBlock [
	^ self  
		inject: 0 seconds 
		into: [ :total  :anEventsGrouper | 
			total + (aBlock value: anEventsGrouper) ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> toolCallsSummarizers [
	^ (GtLToolCallSummarizersRegistry defaultSpecifications
			select: [ :each | each isApplicableToMessages: self ])
			collect: [ :each |
				each buildForMessages: self ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> totalExecutionDuration [
	^ self sumDurations: [ :aToolCall | 
			aToolCall totalExecutionDuration ifNil: [ 0 seconds ] ]
]

{ #category : #accessing }
GtLFunctionToolCallGroup >> totalGcExecutionDuration [
	^ self sumDurations: [ :aToolCall | 
			aToolCall gcExecutionDuration ifNil: [ 0 seconds ] ]
]
