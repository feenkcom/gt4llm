"
Abstract summarizer over a collection of tool calls extracted from chat messages. Subclasses extract specific summary data and expose views for it.
"
Class {
	#name : #GtLToolCallsSummarizer,
	#superclass : #Object,
	#instVars : [
		'originalToolCalls'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #'instance creation' }
GtLToolCallsSummarizer class >> currentSummarizers [
	^ (self allSubclasses reject: [ :each |
			each isAbstract or: [ each isActive  not ] ])
		collect: [ :each | each new ]
]

{ #category : #'instance creation' }
GtLToolCallsSummarizer class >> forMessages: aCollection [
	^ self new
		initializeWithMessages: aCollection;
		yourself
]

{ #category : #testing }
GtLToolCallsSummarizer class >> isAbstract [
	^ self name = #GtLToolCallsSummarizer
]

{ #category : #testing }
GtLToolCallsSummarizer class >> isActive [ 
	^false
]

{ #category : #printing }
GtLToolCallsSummarizer >> gtDisplayOn: aStream [
	 aStream nextPutAll: self title
]

{ #category : #'gt-extensions' }
GtLToolCallsSummarizer >> gtSummaryFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Summary';
		priority: 5;
		text: [ self summaryText asRopedText ]
]

{ #category : #testing }
GtLToolCallsSummarizer >> hasSummaryData [
	^ self relevantToolCalls notEmpty
]

{ #category : #initialization }
GtLToolCallsSummarizer >> initializeWithMessages: aCollection [
	self originalToolCalls: (self toolCallsFromMessages: aCollection)
]

{ #category : #testing }
GtLToolCallsSummarizer >> isRelevant [
	^ self hasSummaryData
]

{ #category : #accessing }
GtLToolCallsSummarizer >> originalToolCalls [
	^ originalToolCalls ifNil: [ #() ]
]

{ #category : #accessing }
GtLToolCallsSummarizer >> originalToolCalls: aCollection [
	originalToolCalls := aCollection
]

{ #category : #accessing }
GtLToolCallsSummarizer >> relevantToolCalls [
	^ #()
]

{ #category : #accessing }
GtLToolCallsSummarizer >> summaryText [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLToolCallsSummarizer >> title [
	^ self subclassResponsibility
]

{ #category : #enumerating }
GtLToolCallsSummarizer >> toolCallsDo: aBlock [
	self originalToolCalls do: aBlock
]

{ #category : #private }
GtLToolCallsSummarizer >> toolCallsFromMessages: aCollection [
	| toolCalls |
	toolCalls := OrderedCollection new.
	aCollection do: [ :each |
		each messagesDo: [ :aMessage |
			aMessage isToolMessage ifTrue: [ toolCalls add: aMessage toolCall ] ] ].
	^ toolCalls
]

{ #category : #enumerating }
GtLToolCallsSummarizer >> toolCallsSelect: aBlock [
	^ self originalToolCalls select: aBlock
]
