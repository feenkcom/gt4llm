Class {
	#name : #GtLlmWardleyMapTopicStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapTopicStep class >> stepName [
	^ 'Wardley map topic setter'
]

{ #category : #accessing }
GtLlmWardleyMapTopicStep >> runStep: aContext [
	| data |
	data := aContext lastResult.

	aContext instance topic: data.

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Topic successfully set';
				checker: self)
]
