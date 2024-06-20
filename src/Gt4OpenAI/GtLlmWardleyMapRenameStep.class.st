Class {
	#name : #GtLlmWardleyMapRenameStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapRenameStep class >> stepName [
	^ 'Wardley map rename step'
]

{ #category : #accessing }
GtLlmWardleyMapRenameStep >> parseJsonFor: aContext [
	^ STONJSON fromString: aContext lastResult code source
]

{ #category : #accessing }
GtLlmWardleyMapRenameStep >> runStep: aContext [
	| data |
	data := self parseJsonFor: aContext.
	data
		keysAndValuesDo: [ :name :options | aContext instance addRenameFor: name withOptions: options ].

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully connected';
				checker: self)
]
