"
Summarizes overall example executions found in tool calls, keeping the latest status for each example.
"
Class {
	#name : #GtLOverallExampleExecutionsSummarizer,
	#superclass : #GtLToolCallsSummarizer,
	#instVars : [
		'latestStatusesByExample',
		'runsByExample',
		'relevantToolCalls'
	],
	#category : 'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLOverallExampleExecutionsSummarizer class >> isActive [ 
	^false
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> exampleRunSummaries [
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
GtLOverallExampleExecutionsSummarizer >> exampleStatusesFromModel: aModel do: aBlock [
	aModel ifNil: [ ^ self ].
	aModel class = GtLExampleWithResultStatus ifTrue: [ ^ aBlock value: aModel ].
	aModel class = GtLExampleWithResultStatuses ifTrue: [ ^ aModel exampleWithStatuses do: aBlock ]
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsSummarizer >> gtExampleRunCountsFor: aView [
	<gtView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Runs by examples';
		priority: 35;
		items: [ self exampleRunSummaries ];
		column: 'Class' text: [ :each | (each at: #exampleReference) exampleClassName ];
		column: 'Method' text: [ :each | (each at: #exampleReference) methodName ];
		column: 'Runs' text: [ :each | (each at: #runs) size ] width: 60;
		column: 'Passes' text: [ :each | (each at: #passes) size asString ] width: 60;
		column: 'Failures' text: [ :each | (each at: #failures) size asString ] width: 70;
		column: 'Errors' text: [ :each | (each at: #errors) size asString ] width: 60;
		column: 'Skipped' text: [ :each | (each at: #skipped) size asString ] width: 70;
		send: [ :each | each at: #runs ]
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsSummarizer >> gtLatestStatusesFor: aView [
	<gtView>
		self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Latest example runs';
		priority: 32;
		items: [ self latestStatuses ];
		column: 'Class' text: [ :each | each exampleReference exampleClassName ];
		column: 'Method' text: [ :each | each exampleReference methodName ];
		column: 'Status' text: [ :each | each statusText ];
		send: [ :each | each exampleWithResult ]
]

{ #category : #'gt-extensions' }
GtLOverallExampleExecutionsSummarizer >> gtOverallStatusSummaryFor: aView [
	<gtView>
	<gtLlmView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Overall status summary';
		priority: 20;
		items: [ self overallSummaryEntries ];
		column: 'Label' text: [ :each | each at: #label ];
		column: 'Value' text: [ :each | (each at: #value) asString ] width: 100;
		send: [ :each | (each at: #object) value ];
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect summarizer'
			action: [ :aButton |
				aButton phlow spawnObject: self ];
		actionUpdateButton
]

{ #category : #initialization }
GtLOverallExampleExecutionsSummarizer >> initialize [
	super initialize.
	latestStatusesByExample := Dictionary new.
	runsByExample := Dictionary new.
	relevantToolCalls := OrderedCollection new
]

{ #category : #initialization }
GtLOverallExampleExecutionsSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantToolCalls := self toolCallsSelect: [ :each |
		#(exampleMethodRun examplesInClassesRun) includes: each name asSymbol ].
	self rebuildLatestStatuses
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> latestStatuses [
	^ latestStatusesByExample values asArray
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> numberOfExamples [
	^ runsByExample size
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> overallStatusSummaries [
	^ self statusCounts associations
		asSortedCollection: [ :a :b | a key asString <= b key asString ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> overallSummaryEntries [
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
GtLOverallExampleExecutionsSummarizer >> processToolCall: aToolCall [
	| model |
	model := aToolCall result ifNotNil: [ :aResult | aResult model ].
	self exampleStatusesFromModel: model do: [ :eachStatus |
		| exampleReference |
		exampleReference := eachStatus exampleReference.
		(runsByExample at: exampleReference ifAbsentPut: [ OrderedCollection new ]) add: eachStatus.
		latestStatusesByExample at: exampleReference put: eachStatus ]
]

{ #category : #private }
GtLOverallExampleExecutionsSummarizer >> rebuildLatestStatuses [
	latestStatusesByExample := Dictionary new.
	runsByExample := Dictionary new.
	self relevantToolCalls do: [ :each | self processToolCall: each ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> relevantToolCalls [
	^ relevantToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> runsOf: anExampleReference [
	^ runsByExample at: anExampleReference ifAbsent: [ #() ]
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> statusCounts [
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
GtLOverallExampleExecutionsSummarizer >> summaryText [
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
GtLOverallExampleExecutionsSummarizer >> title [
	^ 'Overall example executions'
]

{ #category : #accessing }
GtLOverallExampleExecutionsSummarizer >> totalRuns [
	^ runsByExample values
		inject: 0
		into: [ :sum :each | sum + each size ]
]
