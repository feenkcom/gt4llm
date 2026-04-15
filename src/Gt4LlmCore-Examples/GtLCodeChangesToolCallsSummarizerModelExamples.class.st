"
Examples for code changes tool call summarizer that build the domain objects directly without executing tools.
"
Class {
	#name : #GtLCodeChangesToolCallsSummarizerModelExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : 'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerModelExamples >> messagesGroupWithCodeChangesSummary [
	<gtExample>
	| group classResult methodResult classToolCall methodToolCall |
	group := GtLMessagesGroup new.

	classResult := GtLClassCommentChangeResult new
		updatedClass: Object;
		status: 'changed';
		oldClassComment: '';
		newClassComment: 'Updated comment';
		yourself.
	classToolCall := GtLFunctionToolCall new
		name: 'changeClassOrTraitComment';
		performedByTool: GtLMagritteToolForClassCommentChange new;
		arguments: (Dictionary new
			at: 'className' put: 'Object';
			at: 'classComment' put: 'Updated comment';
			yourself);
		result: (GtLWrappedObjectModel new name: 'result'; model: classResult; yourself);
		yourself.
	group add: (GtLToolMessage new
		toolCall: classToolCall;
		output: classToolCall result;
		yourself).

	methodResult := GtLMethodCompilationResult new
		status: 'compiled';
		targetMethodReference: (GtLMethodReference new
			methodClassName: 'Object';
			methodName: 'llmCodeChangesExample';
			classSide: false;
			yourself);
		yourself.
	methodToolCall := GtLFunctionToolCall new
		name: 'compileMethod';
		performedByTool: GtLMagritteToolForMethodCompilation new;
		arguments: (Dictionary new at: 'methodRequest' put: Dictionary new; yourself);
		result: (GtLWrappedObjectModel new name: 'result'; model: methodResult; yourself);
		yourself.
	group add: (GtLToolMessage new
		toolCall: methodToolCall;
		output: methodToolCall result;
		yourself).

	self assert: ((group messageSummarizers detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ]) codeChanges size) equals: 2.
	^ group
]
