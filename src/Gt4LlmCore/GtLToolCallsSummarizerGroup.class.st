Class {
	#name : #GtLToolCallsSummarizerGroup,
	#superclass : #GtLGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #views }
GtLToolCallsSummarizerGroup >> gItemsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Tool summarizers';
		priority: 30;
		items: [ self items ];
		column: 'Summary' 
			text: [ :each | each title ];
		column: 'Details' text: [ :each | 
			each summaryText ];
		column: 'Has data' 
			text: [ :each | 
				each hasSummaryData ifTrue: [ 'yes' ] ifFalse: [ 'no' ] ]
			width: 100
]
