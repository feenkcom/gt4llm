"
Summarizes overall SUnit test executions found in tool calls, keeping the latest status for each test case.
"
Class {
	#name : #GtLOverallSUnitTestExecutionsSummarizer,
	#superclass : #GtLToolCallsSummarizer,
	#instVars : [
		'latestStatusesByTestCase',
		'runsByTestCase',
		'relevantToolCalls'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #testing }
GtLOverallSUnitTestExecutionsSummarizer class >> isActive [
	^ true
]

{ #category : #'gt-views' }
GtLOverallSUnitTestExecutionsSummarizer >> gtLatestStatusesFor: aView [
	<gtView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Last test status';
		priority: 32;
		items: [ self latestStatuses ];
		column: 'Class' text: [ :each | each testCase className ];
		column: 'Method' text: [ :each | each testCase selector ];
		column: 'Status' text: [ :each | each statusText ];
		send: [ :each | each testCaseWithResult ]
]

{ #category : #'gt-views' }
GtLOverallSUnitTestExecutionsSummarizer >> gtOverallStatusSummaryFor: aView [
	<gtView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'SUnit runs overview';
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

{ #category : #'gt-views' }
GtLOverallSUnitTestExecutionsSummarizer >> gtRunsAndTestsFor: aView [
	<gtView>
	<gtLlmView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Runs & tests';
		priority: 33;
		items: [ relevantToolCalls ];
		column: 'Total tests'
			text: [ :each | each result model runCount ]
			width: 90;
		column: 'Successes'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						each result model passedCount isZero
							ifTrue: [ '' ]
							ifFalse: [ each result model passedCount ] ];
					width: 80;
					background: [ :each | 
						each result model passedCount isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors successBackgroundColor ] ] ];
		column: 'Failures'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						each result model failureCount isZero
							ifTrue: [ '' ]
							ifFalse: [ each result model failureCount ] ];
					width: 80;
					background: [ :each | 
						each result model failureCount isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors failureBackgroundColor ] ] ];
		column: 'Errors'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						each result model errorCount isZero
							ifTrue: [ '' ]
							ifFalse: [ each result model errorCount ] ];
					width: 80;
					background: [ :each | 
						each result model errorCount isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors errorBackgroundColor ] ] ];
		column: 'Skipped'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						each result model skippedCount isZero
							ifTrue: [ '' ]
							ifFalse: [ each result model skippedCount ] ];
					width: 80;
					background: [ :each | 
						each result model skippedCount isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors neutralBackgroundColor ] ] ];
			send: [ :each | each result model ]
]

{ #category : #'gt-views' }
GtLOverallSUnitTestExecutionsSummarizer >> gtTestRunCountsFor: aView [
	<gtView>
	self hasSummaryData ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Tests & runs';
		priority: 35;
		items: [ self testRunSummaries ];
		column: 'Class' text: [ :each | (each at: #testReference) key ];
		column: 'Method' text: [ :each | (each at: #testReference) value ];
		column: 'Runs' text: [ :each | (each at: #runs) size ] width: 60;
		column: 'Successes'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						(each at: #passes) size isZero
							ifTrue: [ '' ]
							ifFalse: [ (each at: #passes) size  ] ];
					width: 80;
					background: [ :each | 
						(each at: #passes) size isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors successBackgroundColor ] ] ];
		column: 'Failures'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						(each at: #failures) size isZero
							ifTrue: [ '' ]
							ifFalse: [ (each at: #failures) size  ] ];
					width: 80;
					background: [ :each | 
						(each at: #failures) size isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors failureBackgroundColor ] ] ];
		column: 'Errors'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						(each at: #errors) size isZero
							ifTrue: [ '' ]
							ifFalse: [ (each at: #errors) size  ] ];
					width: 80;
					background: [ :each | 
						(each at: #errors) size isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors errorBackgroundColor ] ] ];
		column: 'Skipped'
			textDo: [ :aColumn | 
				aColumn
					format: [ :each | 
						(each at: #skipped) size isZero
							ifTrue: [ '' ]
							ifFalse: [ (each at: #skipped) size  ] ];
					width: 80;
					background: [ :each | 
						(each at: #skipped) size isZero
							ifTrue: [ Color transparent ]
							ifFalse: [ BrGlamorousColors neutralBackgroundColor ] ] ];
		send: [ :each | each at: #runs ]
]

{ #category : #initialization }
GtLOverallSUnitTestExecutionsSummarizer >> initialize [
	super initialize.
	latestStatusesByTestCase := Dictionary new.
	runsByTestCase := Dictionary new.
	relevantToolCalls := OrderedCollection new
]

{ #category : #initialization }
GtLOverallSUnitTestExecutionsSummarizer >> initializeWithMessages: aCollection [
	super initializeWithMessages: aCollection.
	relevantToolCalls := self toolCallsSelect: [ :each |
		#(testsInClassesRun) includes: each name asSymbol ].
	self rebuildLatestStatuses
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> latestStatuses [
	^ latestStatusesByTestCase values asArray
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> numberOfTests [
	^ runsByTestCase size
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> overallStatusSummaries [
	^ self statusCounts associations
		asSortedCollection: [ :a :b | a key asString <= b key asString ]
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> overallSummaryEntries [
	| entries |
	entries := OrderedCollection new.
	entries add: ({ 
		#label -> 'Tests'. 
		#value -> self numberOfTests. 
		#object -> [ self latestStatuses ] } asDictionary).
	entries add: ({ 
		#label -> 'Test runs'. 
		#value -> self totalRuns. 
		#object -> [ 
				runsByTestCase values 
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
				runsByTestCase valuesDo: [ :eachStatuses |
					eachStatuses do: [ :eachStatus |
						eachStatus statusText = key ifTrue: [ matchingRuns add: eachStatus ] ] ].
				matchingRuns ] } asDictionary) ].
	^ entries
]

{ #category : #processing }
GtLOverallSUnitTestExecutionsSummarizer >> processToolCall: aToolCall [
	| model |
	model := aToolCall result ifNotNil: [ :aResult | aResult model ].
	self testStatusesFromModel: model do: [ :eachStatus |
		| testReference |
		testReference := eachStatus testCase className -> eachStatus testCase selector.
		(runsByTestCase at: testReference ifAbsentPut: [ OrderedCollection new ]) add: eachStatus.
		latestStatusesByTestCase at: testReference put: eachStatus ]
]

{ #category : #processing }
GtLOverallSUnitTestExecutionsSummarizer >> rebuildLatestStatuses [
	latestStatusesByTestCase := Dictionary new.
	runsByTestCase := Dictionary new.
	self relevantToolCalls do: [ :each | self processToolCall: each ]
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> relevantToolCalls [
	^ relevantToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> runsOf: aTestReference [
	^ runsByTestCase at: aTestReference ifAbsent: [ #() ]
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> statusCounts [
	| counts |
	counts := OrderedDictionary new.
	runsByTestCase valuesDo: [ :eachStatuses |
		eachStatuses do: [ :eachStatus |
			counts
				at: eachStatus statusText
				put: ((counts at: eachStatus statusText ifAbsent: [ 0 ]) + 1) ] ].
	^ counts
]

{ #category : #printing }
GtLOverallSUnitTestExecutionsSummarizer >> summaryText [
	| counts details |
	self hasSummaryData ifFalse: [ ^ 'No SUnit test executions' ].
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
		format: { self numberOfTests. self totalRuns. details }
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> testRunSummaries [
	^ runsByTestCase associations collect: [ :eachAssociation |
		| statuses |
		statuses := eachAssociation value.
		{ 
			#testReference -> eachAssociation key.
			#runs -> statuses.
			#passes -> (statuses select: [ :each | each isPassedResult ]).
			#failures -> (statuses select: [ :each | each isFailureResult ]).
			#errors -> (statuses select: [ :each | each isErrorResult ]).
			#skipped -> (statuses select: [ :each | each isSkippedResult ])
		} asDictionary ]
]

{ #category : #processing }
GtLOverallSUnitTestExecutionsSummarizer >> testStatusesFromModel: aModel do: aBlock [
	aModel ifNil: [ ^ self ].
	aModel class = GtLTestCaseWithResultStatus ifTrue: [ ^ aBlock value: aModel ].
	aModel class = GtLTestCasesWithResultStatuses ifTrue: [ ^ aModel testCases do: aBlock ]
]

{ #category : #printing }
GtLOverallSUnitTestExecutionsSummarizer >> title [
	^ 'Overall SUnit test executions'
]

{ #category : #accessing }
GtLOverallSUnitTestExecutionsSummarizer >> totalRuns [
	^ runsByTestCase values
		inject: 0
		into: [ :sum :each | sum + each size ]
]
