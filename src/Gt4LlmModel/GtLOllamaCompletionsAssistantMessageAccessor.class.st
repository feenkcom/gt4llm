Class {
	#name : #GtLOllamaCompletionsAssistantMessageAccessor,
	#superclass : #GtLModelAssistantMessageAccessor,
	#category : #'Gt4LlmModel-MessageAccessors'
}

{ #category : #accessing }
GtLOllamaCompletionsAssistantMessageAccessor >> choices [

	^ self rawData at: 'choices'
]

{ #category : #accessing }
GtLOllamaCompletionsAssistantMessageAccessor >> content [

	^ self message at: 'content'
]

{ #category : #accessing }
GtLOllamaCompletionsAssistantMessageAccessor >> message [

	^ self choices first at: 'message'
]

{ #category : #accessing }
GtLOllamaCompletionsAssistantMessageAccessor >> reasoning [

	^ self message at: 'reasoning'
]

{ #category : #accessing }
GtLOllamaCompletionsAssistantMessageAccessor >> role [

	^ self message at: 'role'
]
