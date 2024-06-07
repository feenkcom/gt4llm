Class {
	#name : #GtLlmWardleyMapExplanationStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples'
}

{ #category : #accessing }
GtLlmWardleyMapExplanationStep class >> stepName [
	^ 'Explanation'
]

{ #category : #accessing }
GtLlmWardleyMapExplanationStep >> runStep: aContext [
	| data |
	data := aContext lastResult code source.
	aContext chat announce: (GtLlmSpawnRequestAnnouncement new object: data).

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully explained';
				checker: self)
]
