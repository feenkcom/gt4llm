"
Group of tool call summarizer specifications.
"
Class {
	#name : #GtLToolCallSummarizerSpecificationsGroup,
	#superclass : #GtBasicGroup,
	#category : #'Gt4LlmCore-Summaries'
}

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
