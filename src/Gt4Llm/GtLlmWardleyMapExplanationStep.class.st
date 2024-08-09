Class {
	#name : #GtLlmWardleyMapExplanationStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapExplanationStep class >> stepName [
	^ 'Explanation'
]

{ #category : #accessing }
GtLlmWardleyMapExplanationStep >> runStep: aContext [
	| explanation |
	explanation := aContext lastResult.

	explanation ifEmpty: [ ^ self ].

	aContext chat
		announce: (GtLlmSpawnRequestAnnouncement new
				object: (GtLlmWardleyMapExplanation new explanation: explanation)).

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Nodes successfully explained';
				checker: self)
]
