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
	| explanation |
	explanation := aContext lastResult code source.
	aContext chat
		announce: (GtLlmSpawnRequestAnnouncement new
				object: (GtLlmWardleyMapExplanation new explanation: explanation)).

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully explained';
				checker: self)
]
