Class {
	#name : #GtLFunctionToolCallsGroup,
	#superclass : #GtLGroup,
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCallsGroup >> averageExecutionDuration [
	| durations totalDuration | 
	
	durations := (self collect: [ :each | each executionDuration ])
		reject: [ :each | each isNil ].
	totalDuration := durations  
		inject: 0 seconds 
		into: [ :total  :aDuration | 
			total + aDuration ].
			
	^ totalDuration / durations size
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> executionDuration [
	^ self sumDurations: [ :aToolCall | 
			aToolCall executionDuration ifNil: [ 0 seconds ] ]
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
		column: 'Duration' text: [ :each | 
			each executionDuration 
				ifNil: [ '' ] 
				ifNotNil: [ :aDuration | 
					aDuration gtPreciseHumanReadableString ] ]
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
				aToolExecution executionDuration ]
]

{ #category : #accessing }
GtLFunctionToolCallsGroup >> longestExecutionDuration [
	| durations | 
	
	durations := (self collect: [ :each | each executionDuration ])
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
