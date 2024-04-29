Class {
	#name : #GtLlmWardleyMapPositionStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapPositionStep class >> stepName [
	^ 'Wardley map position setter'
]

{ #category : #accessing }
GtLlmWardleyMapPositionStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	data
		do: [ :aPosition | 
			aContext instance
				setNode: (aPosition at: 'node')
				toX: (aPosition at: 'x')
				andY: (aPosition at: 'y') ].

	aContext
		addResult: (GtLlmStepStringSuccess new
				contentString: 'Nodes successfully positioned';
				checker: self)
]
