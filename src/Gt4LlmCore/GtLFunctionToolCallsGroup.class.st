Class {
	#name : #GtLFunctionToolCallsGroup,
	#superclass : #GtLGroup,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCallsGroup >> averageExecutionDuration [
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
GtLFunctionToolCallsGroup >> durationTextFor: aDuration [
	^ aDuration
		ifNil: [ '' ]
		ifNotNil: [ :theDuration |
			theDuration gtPreciseHumanReadableString ]
]

{ #category : #views }
GtLFunctionToolCallsGroup >> gtItemsFor: aView [
	<gtView>
	
	items ifNil: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		items: [ items ];
		column: 'Tool name' text: [ :each | each name ];
		column: 'Tool class' text: [ :each | each tool class name ];
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
GtLFunctionToolCallsGroup >> lastExecution [
	^ (self sorted: [:each | each executionEndTime ] ascending)
		ifEmpty: [ nil ] 
		ifNotEmpty: [ :each | each last ]
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> lastExecutionDuration [
	^ self lastExecution 
			ifNil: [ nil ] 
			ifNotNil: [ :aToolExecution |
				aToolExecution totalExecutionDuration ]
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> longestExecutionDuration [
	| durations | 
	
	durations := (self collect: [ :each | each totalExecutionDuration ])
		reject: [ :each | each isNil ].
	durations ifEmpty: [ ^ nil ].
	
	^ durations max
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> sumDurations: aBlock [
	^ self  
		inject: 0 seconds 
		into: [ :total  :anEventsGrouper | 
			total + (aBlock value: anEventsGrouper) ]
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> totalExecutionDuration [
	^ self sumDurations: [ :aToolCall | 
			aToolCall totalExecutionDuration ifNil: [ 0 seconds ] ]
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> totalGcExecutionDuration [
	^ self sumDurations: [ :aToolCall | 
			aToolCall gcExecutionDuration ifNil: [ 0 seconds ] ]
]
