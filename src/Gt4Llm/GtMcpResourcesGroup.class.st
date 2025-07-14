Class {
	#name : #GtMcpResourcesGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtMcpResourcesGroup >> gtResourcesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Resources';
		priority: 1;
		items: [ self items ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'URI' text: #uri
]
