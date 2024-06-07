Class {
	#name : #GtLlmWardleyMapNodeStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
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
				content: aContext instance;
				contentString: 'Nodes successfully added';
				checker: self)
]
