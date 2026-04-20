"
Examples for code changes tool call summarizer.
"
Class {
	#name : #GtLCodeChangesToolCallsSummarizerExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#instVars : [
		'createdClasses'
	],
	#category : 'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> cleanupCreatedClasses [
	createdClasses ifNil: [ ^ self ].
	createdClasses do: [ :eachClassName | self removeClassNamedIfPresent: eachClassName ].
	createdClasses removeAll
]

{ #category : #initialization }
GtLCodeChangesToolCallsSummarizerExamples >> initialize [
	super initialize.
	createdClasses := OrderedCollection new
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedClassCommentChange [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group createToolCall commentToolCall removeToolCall summarizer className |
	
	group := GtLMessagesGroup new.
	className := 'GtLTemporarySummarizerCommentChangeClass'.
	self removeClassNamedIfPresent: className.
	
	createToolCall := self performTrackedClassCreationNamed: className.
	group add: (self toolMessageFrom: createToolCall).
	
	commentToolCall := self performClassCommentChangeFor: (Smalltalk classNamed: className asSymbol) to: 'Temporary comment for summarizer example'.
	group add: (self toolMessageFrom: commentToolCall).
	
	removeToolCall := self performClassRemovalNamed: className.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group messageSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 3.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedClassCreationAndRemoval [
	<gtExample>
	<after: #cleanupCreatedClasses>
	| group className createToolCall removeToolCall summarizer |
	
	group := GtLMessagesGroup new.
	className := 'GtLTemporarySummarizerExampleClass'.
	self removeClassNamedIfPresent: className.
	
	createToolCall := self performTrackedClassCreationNamed: className.
	group add: (self toolMessageFrom: createToolCall).
	
	removeToolCall := self performClassRemovalNamed: className.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group messageSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 2.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedMethodCompilation [
	<gtExample>
	| group toolCall summarizer source selector |
	
	group := GtLMessagesGroup new.
	selector := #llmTemporaryCompiledMethodForSummarizer.
	source := 'llmTemporaryCompiledMethodForSummarizer ^ 42'.
	
	self removeSelector: selector fromClass: self class.
	toolCall := self performMethodCompilationFor: self class selector: selector source: source protocol: 'examples-temp'.
	group add: (self toolMessageFrom: toolCall).
	
	summarizer := group messageSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 1.
	self removeSelector: selector fromClass: self class.
	
	^ group
]

{ #category : #examples }
GtLCodeChangesToolCallsSummarizerExamples >> messagesGroupWithExecutedMethodCompilationAndRemoval [
	<gtExample>
	| group compileToolCall removeToolCall summarizer selector source |
	
	group := GtLMessagesGroup new.
	selector := #llmTemporaryMethodForRemovalSummarizer.
	source := 'llmTemporaryMethodForRemovalSummarizer ^ 7'.
	
	self removeSelector: selector fromClass: self class.
	compileToolCall := self performMethodCompilationFor: self class selector: selector source: source protocol: 'examples-temp'.
	group add: (self toolMessageFrom: compileToolCall).
	self assert: (self class includesSelector: selector).
	
	removeToolCall := self performMethodRemovalFor: self class selector: selector.
	group add: (self toolMessageFrom: removeToolCall).
	
	summarizer := group messageSummarizers 
		detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer codeChanges size equals: 2.
	
	^ group
]

{ #category : #utilities }
GtLCodeChangesToolCallsSummarizerExamples >> performTrackedClassCreationNamed: aClassName [
	| toolCall |
	toolCall := self performClassCreationNamed: aClassName.
	self trackCreatedClassNamed: aClassName.
	^ toolCall
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> removeClassNamedIfPresent: aClassName [
	(Smalltalk hasClassNamed: aClassName asSymbol) ifTrue: [ 
		(Smalltalk classNamed: aClassName asSymbol) removeFromSystem ]
]

{ #category : #private }
GtLCodeChangesToolCallsSummarizerExamples >> trackCreatedClassNamed: aClassName [
	createdClasses add: aClassName
]
