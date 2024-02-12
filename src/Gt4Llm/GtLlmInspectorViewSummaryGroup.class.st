Class {
	#name : #GtLlmInspectorViewSummaryGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Summarizer'
}

{ #category : #accessing }
GtLlmInspectorViewSummaryGroup >> gtPhlowViewsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Views';
		priority: 1;
		items: [ self items ];
		column: 'Selector' text: #selector;
		column: 'Code' text: #code weight: 4
]
