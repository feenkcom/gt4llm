"
Represents an Ollama-compatible completions response payload backed by raw JSON data.
"
Class {
	#name : #GtLOllamaCompletionsResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> choices [
	^ (self rawData at: 'choices') collect: [ :each | GtLOllamaCompletionsChoiceEntity new rawData: each ]
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> created [
	^ self rawData at: 'created'
]

{ #category : #'as yet unclassified' }
GtLOllamaCompletionsResponseEntity >> gtChoicesFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Choices';
		priority: 20;
		items: [ self choices ];
		column: 'Choice' text: [ :choice | choice gtDisplayString ]
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> object [
	^ self rawData at: 'object'
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> systemFingerprint [
	^ self rawData at: 'system_fingerprint'
]

{ #category : #accessing }
GtLOllamaCompletionsResponseEntity >> usage [
	^ GtLOllamaCompletionsUsageEntity new rawData: (self rawData at: 'usage')
]
