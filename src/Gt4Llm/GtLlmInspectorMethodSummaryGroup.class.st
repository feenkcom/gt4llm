Class {
	#name : #GtLlmInspectorMethodSummaryGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmInspectorMethodSummaryGroup >> gtPhlowMethodsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Methods';
		priority: 1;
		items: [ self items ];
		column: 'Selector' text: #name
]
