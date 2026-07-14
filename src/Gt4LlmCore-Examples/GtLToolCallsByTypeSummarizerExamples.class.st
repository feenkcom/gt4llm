"
Examples for GtLToolCallsByTypeSummarizer.
"
Class {
	#name : #GtLToolCallsByTypeSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #examples }
GtLToolCallsByTypeSummarizerExamples >> byTypeSummarizerFromMessagesGroup [
	<gtExample>
	| group summarizer |
	group := self messagesGroupWithByTypeToolCalls.
	summarizer := group toolCallsSummarizers detect: [ :each | each class = GtLToolCallsByTypeSummarizer ].
	self assert: summarizer groupedToolCalls size equals: 4.
	^ summarizer
]

{ #category : #examples }
GtLToolCallsByTypeSummarizerExamples >> byTypeSummarizerGroupedToolDurations [
	<gtExample>
	| summarizer lookupGroup searchGroup |
	summarizer := self byTypeSummarizerWithFixedToolCalls.
	lookupGroup := summarizer groupedToolCallsForToolNamed: 'lookupClass'.
	searchGroup := summarizer groupedToolCallsForToolNamed: 'searchForClasses'.
	
	self assert: lookupGroup size equals: 3.
	self assert: lookupGroup totalExecutionDuration equals: 23 seconds.
	self assert: lookupGroup averageExecutionDuration equals: (23 seconds / 3).
	self assert: lookupGroup longestExecutionDuration equals: 11 seconds.
	
	self assert: searchGroup size equals: 1.
	self assert: searchGroup totalExecutionDuration equals: 2 seconds.
	self assert: searchGroup averageExecutionDuration equals: 2 seconds.
	self assert: searchGroup longestExecutionDuration equals: 2 seconds.
	
	^ summarizer
]

{ #category : #examples }
GtLToolCallsByTypeSummarizerExamples >> byTypeSummarizerSummary [
	<gtExample>
	| summarizer |
	summarizer := self byTypeSummarizerWithFixedToolCalls.
	self assert: summarizer summaryText equals: '4 tool types, 4 tool calls, 25s 0ms total duration'.
	^ summarizer summaryText
]

{ #category : #examples }
GtLToolCallsByTypeSummarizerExamples >> byTypeSummarizerWithFixedToolCalls [
	<gtExample>
	| group summarizer |
	group := self messagesGroupWithByTypeToolCalls.
	summarizer := GtLToolCallsByTypeSummarizer new
		initializeWithMessages: group items;
		yourself.
	self assert: summarizer relevantToolCalls size equals: 4.
	self assert: summarizer groupedToolCalls size equals: 4.
	^ summarizer
]

{ #category : #examples }
GtLToolCallsByTypeSummarizerExamples >> messagesGroupWithByTypeToolCalls [
	<gtExample>
	| group summarizer |
	group := GtLMessagesGroup new.
	group add: (self toolMessageFrom: ((self
		toolCallNamed: 'lookupClass'
		arguments: (Dictionary new at: 'className' put: 'Object'; yourself)
		executionDetails: (self
			fixedExecutionDetailsFrom: '2024-01-01T10:00:00+00:00' asDateAndTime
			to: '2024-01-01T10:00:05+00:00' asDateAndTime))
		performedByTool: GtLMagritteToolForClassLookup new;
		result: (GtLWrappedObjectModel new
			name: 'result';
			model: (GtLClassDescription fromClass: Object);
			yourself);
		yourself)).
	group add: (self toolMessageFrom: ((self
		toolCallNamed: 'lookupClass'
		arguments: (Dictionary new at: 'className' put: 'Collection'; yourself)
		executionDetails: (self
			fixedExecutionDetailsFrom: '2024-01-01T10:01:00+00:00' asDateAndTime
			to: '2024-01-01T10:01:07+00:00' asDateAndTime))
		performedByTool: GtLMagritteToolForClassLookup new;
		result: (GtLWrappedObjectModel new
			name: 'result';
			model: (GtLClassDescription fromClass: Collection);
			yourself);
		yourself)).
	group add: (self toolMessageFrom: ((self
		toolCallNamed: 'lookupClass'
		arguments: (Dictionary new at: 'className' put: 'String'; yourself)
		executionDetails: (self
			fixedExecutionDetailsFrom: '2024-01-01T10:02:00+00:00' asDateAndTime
			to: '2024-01-01T10:02:11+00:00' asDateAndTime))
		performedByTool: GtLMagritteToolForClassLookup new;
		result: (GtLWrappedObjectModel new
			name: 'result';
			model: (GtLClassDescription fromClass: String);
			yourself);
		yourself)).
	group add: (self toolMessageFrom: ((self
		toolCallNamed: 'searchForClasses'
		arguments: (Dictionary new at: 'query' put: 'Tool'; yourself)
		executionDetails: (self
			fixedExecutionDetailsFrom: '2024-01-01T10:03:00+00:00' asDateAndTime
			to: '2024-01-01T10:03:02+00:00' asDateAndTime))
		performedByTool: GtLMagritteToolForClassSearch new;
		result: (GtLWrappedObjectModel new
			name: 'result';
			model: (GtLClassesSearchResult fromClasses: { GtLToolCallsByTypeSummarizer. GtLToolCallsSummarizer });
			yourself);
		yourself)).
	summarizer := group toolCallsSummarizers detect: [ :each | each class = GtLToolCallsByTypeSummarizer ].
	self assert: summarizer relevantToolCalls size equals: 4.
	^ group
]
