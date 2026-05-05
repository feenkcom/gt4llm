"
Examples for tool call summarizers registry and specifications.
"
Class {
	#name : #GtLToolCallSummarizersRegistryExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Summarizers'
}

{ #category : #examples }
GtLToolCallSummarizersRegistryExamples >> copiedRegistry [
	<gtExample>
	| registry copy |
	registry := self defaultSpecifications.
	copy := registry copy.
	self assert: copy ~~ registry.
	self assert: copy specifications ~~ registry specifications.
	self assert: copy specifications size equals: registry specifications size.
	self assert: copy currentSummarizers isEmpty.
	^ copy
]

{ #category : #examples }
GtLToolCallSummarizersRegistryExamples >> customSpecificationIsUsed [
	<gtExample>
	| registry specification summarizers |
	registry := GtLToolCallSummarizersRegistry new.
	registry addSpecifications: GtLToolCallSummarizersRegistry defaultSpecifications.
	specification := GtLToolCallSummarizerSpecification forSummarizerClass: GtLOverallExampleExecutionsSummarizer.
	summarizers := registry
		addSpecification: specification;
		summarizersForMessages: self messagesGroupWithToolAndExampleSummaries.
	self assert: (summarizers anySatisfy: [ :each | each class = GtLOverallExampleExecutionsToolCallsSummarizer ]).
	self assert: (summarizers anySatisfy: [ :each | each class = GtLToolCallsByTypeSummarizer ]).
	^ registry
]

{ #category : #examples }
GtLToolCallSummarizersRegistryExamples >> defaultSpecifications [
	<gtExample>
	| registry |
	registry := GtLToolCallSummarizersRegistry new.
	registry addSpecifications: GtLToolCallSummarizersRegistry defaultSpecifications.
	self assert: registry specifications size equals: 4.
	self assert: registry currentSummarizers isEmpty.
	^ registry
]

{ #category : #private }
GtLToolCallSummarizersRegistryExamples >> messagesGroupWithToolAndExampleSummaries [
	^ GtLToolCallsSummarizerExamples new messagesGroupWithToolAndExampleSummaries
]

{ #category : #examples }
GtLToolCallSummarizersRegistryExamples >> relevantSummarizersForMessages [
	<gtExample>
	| registry messages summarizers |
	registry := self defaultSpecifications.
	messages := self messagesGroupWithToolAndExampleSummaries.
	summarizers := registry relevantSummarizersForMessages: messages.
	self assert: summarizers notEmpty.
	self assert: registry currentSummarizers size equals: 3.
	^ registry
]
