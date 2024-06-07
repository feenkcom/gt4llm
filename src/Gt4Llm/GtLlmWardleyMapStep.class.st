Class {
	#name : #GtLlmWardleyMapStep,
	#superclass : #GtLlmCodeStep,
	#category : #'Gt4Llm-Examples - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapStep >> parseJsonFor: aContext [
	^ aContext lastResult code source lines
		reject: #isEmpty
		thenCollect: [ :aLine | STONJSON fromString: aLine ]
]
