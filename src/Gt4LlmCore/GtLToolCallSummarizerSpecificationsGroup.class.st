"
Group of tool call summarizer specifications.
"
Class {
	#name : #GtLToolCallSummarizerSpecificationsGroup,
	#superclass : #GtBasicGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #enumerating }
GtLToolCallSummarizerSpecificationsGroup >> buildForMessages: aMessagesGroup [
	| applicableSummarisers |
	
	applicableSummarisers := self collect: [ :aSpecification | 
		aSpecification buildForMessages: aMessagesGroup ].
	
	^ GtLToolCallsSummarizerGroup withAll: applicableSummarisers
]

{ #category : #enumerating }
GtLToolCallSummarizerSpecificationsGroup >> buildForToolCalls: aToolCallGroup [
	| applicableSummarisers |
	
	applicableSummarisers := self collect: [ :aToolCall | 
		aToolCall buildForToolCalls: aToolCallGroup ].
	
	^ GtLToolCallsSummarizerGroup withAll: applicableSummarisers
]

{ #category : #'gt-views' }
GtLToolCallSummarizerSpecificationsGroup >> gtItemsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Items';
		priority: 5;
		items: [ self items ];
		column: 'Id' text: [ :each | each id ];
		column: 'Summarizer' text: [ :each | each summarizerClassName ];
		column: 'Active' text: [ :each | each isActive asString ]
]

{ #category : #enumerating }
GtLToolCallSummarizerSpecificationsGroup >> selectApplicableToMessages: aMessagesGroup [
	^ self select: [ :each | each isApplicableToMessages: aMessagesGroup ]
]

{ #category : #enumerating }
GtLToolCallSummarizerSpecificationsGroup >> selectApplicableToToolCalls: aToolCallGroup [
	^ self select: [ :each | each isApplicableToToolCalls: aToolCallGroup ]
]
