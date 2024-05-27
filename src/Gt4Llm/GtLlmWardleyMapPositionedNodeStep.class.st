Class {
	#name : #GtLlmWardleyMapPositionedNodeStep,
	#superclass : #GtLlmWardleyMapNodeStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapPositionedNodeStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	aContext instance clearNodes.
	data do: [ :aNode | aContext instance addNode: (aNode at: 'name') ].
	data
		do: [ :aNode | 
			aContext instance
				setNode: (aNode at: 'name')
				toX: (aNode at: 'x')
				andY: (aNode at: 'y') ].

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully added';
				checker: self)
]
