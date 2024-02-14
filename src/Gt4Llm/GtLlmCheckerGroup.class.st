Class {
	#name : #GtLlmCheckerGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-Groups'
}

{ #category : #accessing }
GtLlmCheckerGroup >> gtCheckersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Checkers';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #name
]
