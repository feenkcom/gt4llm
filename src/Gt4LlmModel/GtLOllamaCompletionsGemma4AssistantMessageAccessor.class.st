Class {
	#name : #GtLOllamaCompletionsGemma4AssistantMessageAccessor,
	#superclass : #GtLModelAssistantMessageAccessor,
	#category : #'Gt4LlmModel-MessageAccessors'
}

{ #category : #accessing }
GtLOllamaCompletionsGemma4AssistantMessageAccessor >> choices [

	^ self rawData at: 'choices'
]

{ #category : #accessing }
GtLOllamaCompletionsGemma4AssistantMessageAccessor >> content [

	^ self message at: 'content'
]

{ #category : #accessing }
GtLOllamaCompletionsGemma4AssistantMessageAccessor >> message [

	^ self choices first at: 'message'
]

{ #category : #accessing }
GtLOllamaCompletionsGemma4AssistantMessageAccessor >> reasoning [

	^ self message at: 'reasoning'
]

{ #category : #accessing }
GtLOllamaCompletionsGemma4AssistantMessageAccessor >> role [

	^ self message at: 'role'
]
