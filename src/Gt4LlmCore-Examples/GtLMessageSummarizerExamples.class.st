"
Examples for message summarizers.
"
Class {
	#name : #GtLMessageSummarizerExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #'examples - support' }
GtLMessageSummarizerExamples >> exampleStatusSuccess [
	<gtExample>
	^ 42
]

{ #category : #examples }
GtLMessageSummarizerExamples >> messagesGroupWithToolAndExampleSummaries [
	<gtExample>
	| group toolCall toolMessage exampleWithResult singleStatus wrappedSingle exampleMethod |
	group := GtLMessagesGroup new.
	exampleMethod := self class >> #exampleStatusSuccess.

	toolCall := GtLFunctionToolCall new
		name: 'exampleMethodRun';
		arguments: (Dictionary new
			at: 'exampleReference' put: 'GtLMessageSummarizerExamples>>exampleStatusSuccess';
			yourself);
		yourself.

	exampleWithResult := GtLExampleWithResult new.
	exampleWithResult
		instVarNamed: 'exampleWithResult' put: (exampleMethod gtExample asExampleWithResult);
		objectId: nil.

	singleStatus := GtLExampleWithResultStatus new.
	singleStatus
		instVarNamed: 'exampleWithResult' put: exampleWithResult;
		objectId: nil.

	wrappedSingle := GtLWrappedModel new
		name: 'example';
		model: singleStatus;
		yourself.

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
	^ group
]
