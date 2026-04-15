"
Summarizes overall example executions found in tool calls, keeping the latest status for each example.
"
Class {
	#name : #GtLOverallExampleExecutionsToolCallsSummarizer,
	#superclass : #GtLToolCallsSummarizer,
	#instVars : [
		'latestStatusesByExample',
		'runsByExample',
		'relevantToolCalls'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> exampleRunSummaries [
	^ runsByExample associations collect: [ :eachAssociation |
		| statuses |
		statuses := eachAssociation value.
		{ 
			#exampleReference -> eachAssociation key.
			#runs -> statuses.
			#passes -> (statuses select: [ :each | each isSuccessResult ]).
			#failures -> (statuses select: [ :each | each isFailureResult ]).
			#errors -> (statuses select: [ :each | each isErrorResult ]).
			#skipped -> (statuses select: [ :each | each isSkippedResult ])
		} asDictionary ]
]

{ #category : #private }
GtLOverallExampleExecutionsToolCallsSummarizer >> exampleStatusesFromModel: aModel do: aBlock [
	aModel ifNil: [ ^ self ].
	aModel class = GtLExampleWithResultStatus ifTrue: [ ^ aBlock value: aModel ].
	aModel class = GtLExampleWithResultStatuses ifTrue: [ ^ aModel exampleWithStatuses do: aBlock ]
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsToolCallsSummarizer >> gtExampleRunCountsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Example run counts';
		priority: 15;
		items: [ self exampleRunSummaries ];
		column: 'Example' text: [ :each | (each at: #exampleReference) gtDisplayString ];
		column: 'Runs' text: [ :each | (each at: #runs) size asString ] width: 60;
		column: 'Passes' text: [ :each | (each at: #passes) size asString ] width: 60;
		column: 'Failures' text: [ :each | (each at: #failures) size asString ] width: 70;
		column: 'Errors' text: [ :each | (each at: #errors) size asString ] width: 60;
		column: 'Skipped' text: [ :each | (each at: #skipped) size asString ] width: 70
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsToolCallsSummarizer >> gtLatestStatusesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Latest statuses';
		priority: 10;
		items: [ latestStatusesByExample associations ];
		column: 'Example' text: [ :each | each key gtDisplayString ];
		column: 'Status' text: [ :each | each value statusText ] width: 120
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsToolCallsSummarizer >> gtOverallStatusSummaryFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Overall status summary';
		priority: 22;
		items: [ self overallSummaryEntries ];
		column: 'Label' text: [ :each | each at: #label ];
		column: 'Value' text: [ :each | (each at: #value) asString ] width: 100;
		send: [ :each | (each at: #object) value ]
]

{ #category : #initialization }
GtLOverallExampleExecutionsToolCallsSummarizer >> initialize [
	super initialize.
	latestStatusesByExample := Dictionary new.
	runsByExample := Dictionary new.
	relevantToolCalls := OrderedCollection new
]

{ #category : #initialization }
GtLOverallExampleExecutionsToolCallsSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantToolCalls := self toolCallsSelect: [ :each |
		#(exampleMethodRun examplesInClassesRun) includes: each name asSymbol ].
	self rebuildLatestStatuses
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> latestStatuses [
	^ latestStatusesByExample values asArray
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> numberOfExamples [
	^ latestStatusesByExample size
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> overallStatusSummaries [
	^ self statusCounts associations
		asSortedCollection: [ :a :b | a key asString <= b key asString ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> overallSummaryEntries [
	| entries |
	entries := OrderedCollection new.
	entries add: ({ 
		#label -> 'Examples'. 
		#value -> self numberOfExamples. 
		#object -> [ self latestStatuses ] } asDictionary).
		
	entries add: ({ 
		#label -> 'Example runs'. 
		#value -> self totalRuns. 
		#object -> [ 
				runsByExample values 
					inject: OrderedCollection new 
					into: [ :all :each | all addAll: each; yourself ] 
			] } asDictionary).
			
	self statusCounts keysAndValuesDo: [ :key :value |
		entries add: ({ 
			#label -> (key capitalized, ' runs'). 
			#value -> value. 
			#object -> [ 
				| matchingRuns |
				matchingRuns := OrderedCollection new.
				runsByExample valuesDo: [ :eachStatuses |
					eachStatuses do: [ :eachStatus |
						eachStatus statusText = key ifTrue: [ matchingRuns add: eachStatus ] ] ].
				matchingRuns ] } asDictionary) ].
	^ entries
]

{ #category : #private }
GtLOverallExampleExecutionsToolCallsSummarizer >> processToolCall: aToolCall [
	| model |
	model := aToolCall result ifNotNil: [ :aResult | aResult model ].
	self exampleStatusesFromModel: model do: [ :eachStatus |
		| exampleReference |
		exampleReference := eachStatus exampleReference.
		(runsByExample at: exampleReference ifAbsentPut: [ OrderedCollection new ]) add: eachStatus.
		latestStatusesByExample at: exampleReference put: eachStatus ]
]

{ #category : #private }
GtLOverallExampleExecutionsToolCallsSummarizer >> rebuildLatestStatuses [
	latestStatusesByExample := Dictionary new.
	runsByExample := Dictionary new.
	self relevantToolCalls do: [ :each | self processToolCall: each ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> relevantToolCalls [
	^ relevantToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> runsOf: anExampleReference [
	^ runsByExample at: anExampleReference ifAbsent: [ #() ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> statusCounts [
	| counts |
	counts := OrderedDictionary new.
	runsByExample valuesDo: [ :eachStatuses |
		eachStatuses do: [ :eachStatus |
			counts
				at: eachStatus statusText
				put: ((counts at: eachStatus statusText ifAbsent: [ 0 ]) + 1) ] ].
	^ counts
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> summaryText [
	| counts details |
	self hasSummaryData ifFalse: [ ^ 'No example executions' ].
	counts := self statusCounts.
	details := String streamContents: [ :stream |
		| first |
		first := true.
		counts keysAndValuesDo: [ :key :value |
			first
				ifTrue: [ first := false ]
				ifFalse: [ stream nextPutAll: ', ' ].
			stream
				nextPutAll: key;
				nextPutAll: ': ';
				print: value ] ].
	^ '{1} tests, {2} runs ({3})'
		format: { self numberOfExamples. self totalRuns. details }
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> title [
	^ 'Overall example executions'
]

{ #category : #accessing }
GtLOverallExampleExecutionsToolCallsSummarizer >> totalRuns [
	| values |
	values := runsByExample values.
	values ifEmpty: [ ^ 0 ].
	^ values sum: [ :each | each size ]
]
