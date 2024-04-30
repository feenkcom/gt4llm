Class {
	#name : #GtLlmWardleyMapConnectionStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapConnectionStep class >> stepName [
	^ 'Wardley map connection setter'
]

{ #category : #accessing }
GtLlmWardleyMapConnectionStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	data
		do: [ :aConnection | 
			aContext instance
				connectNode: (aConnection at: 'from')
				to: (aConnection at: 'to') ].

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully connected';
				checker: self)
]
