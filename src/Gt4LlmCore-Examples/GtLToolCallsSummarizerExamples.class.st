"
Examples for tool call summarizers.
"
Class {
	#name : #GtLToolCallsSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #examples }
GtLToolCallsSummarizerExamples >> exampleStatusSuccess [
	<gtExample>
	^ 42
]

{ #category : #examples }
GtLToolCallsSummarizerExamples >> messagesGroupWithToolAndExampleSummaries [
	<gtExample>
	| group toolCall toolMessage exampleWithResult singleStatus wrappedSingle exampleMethod |
	group := GtLMessagesGroup new.
	exampleMethod := self class >> #exampleStatusSuccess.

	toolCall := GtLFunctionToolCall new
		name: 'exampleMethodRun';
		arguments: (Dictionary new
			at: 'exampleReference' put: 'GtLToolCallsSummarizerExamples>>exampleStatusSuccess';
			yourself);
		yourself.

	exampleWithResult := exampleMethod gtExample asExampleWithResult.

	singleStatus := GtLExampleWithResultStatus new.
	singleStatus
		instVarNamed: 'exampleWithResult' put: exampleWithResult;
		objectId: nil.

	wrappedSingle := GtLWrappedObjectModel new
		name: 'example';
		model: singleStatus;
		yourself.

	toolCall result: wrappedSingle.
	toolMessage := GtLToolMessage new
		toolCall: toolCall;
		output: wrappedSingle;
		yourself.

	group add: toolMessage.
	group add: (GtLToolMessage new
		toolCall: (GtLFunctionToolCall new
			name: 'lookupClass';
			arguments: (Dictionary new at: 'className' put: 'Object'; yourself);
			yourself);
		output: wrappedSingle;
		yourself).

	self assert: group relevantMessageSummarizers size equals: 2.
	self assert: (group messageSummarizers allSatisfy: [ :each | each class inheritsFrom: GtLToolCallsSummarizer ]).
	^ group
]
