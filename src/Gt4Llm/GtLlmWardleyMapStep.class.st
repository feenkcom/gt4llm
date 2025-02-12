Class {
	#name : #GtLlmWardleyMapStep,
	#superclass : #AnObsoleteGtLlmCodeStep,
	#category : #'Gt4Llm-Domain - Wardley Map'
}

{ #category : #accessing }
GtLlmWardleyMapStep >> parseJsonFor: aContext [
	^ aContext lastResult code source lines
		reject: #isEmpty
		thenCollect: [ :aLine | STONJSON fromString: aLine ]
]
