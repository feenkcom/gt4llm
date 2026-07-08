Class {
	#name : #GtLOpenAiResponsesResponseEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> choices [
	^ (self rawData at: 'choices') collect: [ :each | GtLOllamaCompletionsChoiceEntity new rawData: each ]
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> created [
	^ self rawData at: 'created'
]

{ #category : #'as yet unclassified' }
GtLOpenAiResponsesResponseEntity >> gtChoicesFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Choices';
		priority: 20;
		items: [ self choices ];
		column: 'Choice' text: [ :choice | choice gtDisplayString ]
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> id [
	^ self rawData at: 'id'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> object [
	^ self rawData at: 'object'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> systemFingerprint [
	^ self rawData at: 'system_fingerprint'
]

{ #category : #accessing }
GtLOpenAiResponsesResponseEntity >> usage [
	^ GtLOllamaCompletionsUsageEntity new rawData: (self rawData at: 'usage')
]
