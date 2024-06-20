Class {
	#name : #GtLlmWardleyMapMapStep,
	#superclass : #GtLlmWardleyMapStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapMapStep class >> stepName [
	^ 'Wardley map parser'
]

{ #category : #accessing }
GtLlmWardleyMapMapStep >> runStep: aContext [
	| aModel |
	aModel := (GtWardleyMapParser parse: aContext lastResult code source)
			asWardleyMapModel.
	aContext instance proposeModel: aModel.

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Map successfully set';
				checker: self)
]
