Class {
	#name : #GtLToolCallSummarizersRegistry,
	#superclass : #Object,
	#instVars : [
		'specifications',
		'currentSummarizers'
	],
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLToolCallSummarizersRegistry class >> defaultSpecifications [
	^ GtLToolCallSummarizerSpecificationsGroup withAll: (
		(GtLToolCallsSummarizer allSubclasses
			reject: [ :each | each isAbstract ])
			collect: [ :each |
				GtLToolCallSummarizerSpecification forSummarizerClass: each ])
]

{ #category : #'gt-views' }
GtLToolCallSummarizersRegistry class >> gtDefaultSpecificationsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Default specifications';
		priority: 15;
		object: [ self defaultSpecifications ];
		view: #gtItemsFor:
]

{ #category : #initialization }
GtLToolCallSummarizersRegistry >> addDefaultSpecifications [
	self addSpecifications: self class defaultSpecifications
]

{ #category : #accessing }
GtLToolCallSummarizersRegistry >> addSpecification: aSpecification [
	specifications add: aSpecification.
	^ aSpecification
]

{ #category : #accessing }
GtLToolCallSummarizersRegistry >> addSpecifications: aCollection [
	specifications addAll: aCollection
]

{ #category : #building }
GtLToolCallSummarizersRegistry >> currentSummarizerMatching: aSpecification [
	^ currentSummarizers
		detect: [ :each | aSpecification matchesSummarizer: each ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLToolCallSummarizersRegistry >> currentSummarizers [
	^ currentSummarizers
]

{ #category : #'gt-views' }
GtLToolCallSummarizersRegistry >> gtCurrentSummarizersFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Summarizers';
		priority: 5;
		items: [ self currentSummarizers ];
		column: 'Summarizer Type' text: [ :each | each class name ];
		column: 'Decription' text: [ :each | each summaryText ]
]

{ #category : #'gt-views' }
GtLToolCallSummarizersRegistry >> gtSpecificationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Specifications';
		priority: 10;
		object: [ self specifications ];
		view: #gtItemsFor:
]

{ #category : #initialization }
GtLToolCallSummarizersRegistry >> initialize [
	super initialize.
	specifications := GtLToolCallSummarizerSpecificationsGroup new.
	currentSummarizers := #()
]

{ #category : #copying }
GtLToolCallSummarizersRegistry >> postCopy [
	super postCopy.
	specifications := GtLToolCallSummarizerSpecificationsGroup new
		addAll: specifications;
		yourself.
	currentSummarizers := #()
]

{ #category : #building }
GtLToolCallSummarizersRegistry >> relevantSummarizersForMessages: aMessagesGroup [
	^ (self summarizersForMessages: aMessagesGroup)
		select: [ :each | each isRelevant ]
]

{ #category : #accessing }
GtLToolCallSummarizersRegistry >> resetToDefaultSpecifications [
	specifications := GtLToolCallSummarizerSpecificationsGroup new.
	self addDefaultSpecifications.
	currentSummarizers := #()
]

{ #category : #building }
GtLToolCallSummarizersRegistry >> sortedApplicableSpecificationsForMessages: aMessagesGroup [
	^ specifications select: [ :each |
		each isApplicableToMessages: aMessagesGroup ]
]

{ #category : #accessing }
GtLToolCallSummarizersRegistry >> specifications [
	^ specifications
]

{ #category : #building }
GtLToolCallSummarizersRegistry >> summarizersForMessages: aMessagesGroup [
	self updateSummarizersForMessages: aMessagesGroup.
	^ self currentSummarizers
]

{ #category : #building }
GtLToolCallSummarizersRegistry >> updateSummarizersForMessages: aMessagesGroup [
	currentSummarizers := (self sortedApplicableSpecificationsForMessages: aMessagesGroup)
		collect: [ :eachSpecification |
			eachSpecification buildForMessages: aMessagesGroup ].
	^ currentSummarizers
]
