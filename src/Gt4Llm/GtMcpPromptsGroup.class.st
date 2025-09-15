Class {
	#name : #GtMcpPromptsGroup,
	#superclass : #GtLlmGroup,
	#category : #Gt4Llm
}

{ #category : #accessing }
GtMcpPromptsGroup class >> leJsonV4Name [

	^ #gtMcpPromptsGroup
]

{ #category : #'as yet unclassified' }
GtMcpPromptsGroup >> gtPromptsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Prompts';
		priority: 1;
		items: [ self items ];
		column: 'Name'
			text: #name
			weight: 0.5;
		column: 'Description' text: #description;
		column: 'Arguments' text: [ :aPrompt | ',' join: aPrompt arguments ]
]
