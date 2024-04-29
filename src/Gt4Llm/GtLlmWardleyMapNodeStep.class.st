Class {
	#name : #GtLlmWardleyMapNodeStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapNodeStep class >> stepName [
	^ 'Wardley map node creator'
]

{ #category : #accessing }
GtLlmWardleyMapNodeStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	data do: [ :aNode | aContext instance addNode: (aNode at: 'name') ].

	aContext
		addResult: (GtLlmStepStringSuccess new
				contentString: 'Nodes successfully added';
				checker: self)
]
