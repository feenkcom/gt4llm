"
Abstract summarizer over a collection of chat messages. Subclasses extract specific summary data and expose views for it.
"
Class {
	#name : #GtLMessageSummarizer,
	#superclass : #Object,
	#instVars : [
		'originalMessages'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLMessageSummarizer class >> currentSummarizers [
	^ { 
		GtLToolMessagesByTypeSummarizer new.
		GtLOverallExampleExecutionsSummarizer new }
]

{ #category : #'instance creation' }
GtLMessageSummarizer class >> forMessages: aCollection [
	^ self new
		initializeWithMessages: aCollection;
		yourself
]

{ #category : #printing }
GtLMessageSummarizer >> gtDisplayOn: aStream [
	aStream
		nextPutAll: self title;
		nextPutAll: ' — ';
		nextPutAll: self summaryText
]

{ #category : #'gt views' }
GtLMessageSummarizer >> gtSummaryFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Summary';
		priority: 1;
		text: [ self summaryText asRopedText ]
]

{ #category : #testing }
GtLMessageSummarizer >> hasSummaryData [
	^ self subclassResponsibility
]

{ #category : #initialization }
GtLMessageSummarizer >> initializeWithMessages: aCollection [
	| aMessagesGroup |
	aMessagesGroup := GtLMessagesGroup new.
	aCollection do: [ :each | aMessagesGroup add: each ].
	self originalMessages: aMessagesGroup
]

{ #category : #testing }
GtLMessageSummarizer >> isRelevant [
	^ self hasSummaryData
]

{ #category : #enumerating }
GtLMessageSummarizer >> messagesDo: aBlock [
	self originalMessages do: [ :each |
		each messagesDo: aBlock ]
]

{ #category : #enumerating }
GtLMessageSummarizer >> messagesSelect: aBlock [
	| all |
	all := GtLMessagesGroup new.
	self messagesDo: [ :eachMessage |
		(aBlock value: eachMessage) ifTrue: [ all add: eachMessage ] ].
	^ all
]

{ #category : #accessing }
GtLMessageSummarizer >> originalMessages [
	^ originalMessages ifNil: [ #() ]
]

{ #category : #accessing }
GtLMessageSummarizer >> originalMessages: aCollection [
	originalMessages := aCollection
]

{ #category : #accessing }
GtLMessageSummarizer >> relevantMessages [
	^ #()
]

{ #category : #accessing }
GtLMessageSummarizer >> summaryText [
	^ ''
]

{ #category : #accessing }
GtLMessageSummarizer >> title [
	^ self class name
]
