Class {
	#name : #GtLOllamaGenerateAssistantMessageAccessor,
	#superclass : #GtLModelAssistantMessageAccessor,
	#category : #'Gt4LlmModel-MessageAccessors'
}

{ #category : #'as yet unclassified' }
GtLOllamaGenerateAssistantMessageAccessor >> content [

	^ self rawData at: 'response'
]

{ #category : #'as yet unclassified' }
GtLOllamaGenerateAssistantMessageAccessor >> reasoning [

	^ self rawData at: 'thinking'
]
