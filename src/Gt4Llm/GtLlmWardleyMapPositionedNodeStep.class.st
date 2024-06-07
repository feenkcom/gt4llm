Class {
	#name : #GtLlmWardleyMapPositionedNodeStep,
	#superclass : #GtLlmWardleyMapNodeStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapPositionedNodeStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	aContext instance setNodes: data.

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully added';
				checker: self)
]
