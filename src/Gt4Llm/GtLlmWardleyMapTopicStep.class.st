Class {
	#name : #GtLlmWardleyMapTopicStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapTopicStep class >> stepName [
	^ 'Wardley map topic setter'
]

{ #category : #accessing }
GtLlmWardleyMapTopicStep >> runStep: aContext [
	| data |
	data := aContext lastResult code source.

	aContext instance topic: data.

	aContext
		addResult: (GtLlmStepStringSuccess new
				content: aContext instance;
				contentString: 'Topic successfully set';
				checker: self)
]
