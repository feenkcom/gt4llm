"
Represents an OpenAI-compatible completions request payload backed by raw JSON data.
"
Class {
	#name : #GtLOpenAiCompletionsRequestEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #'as yet unclassified' }
GtLOpenAiCompletionsRequestEntity >> gtMessagesFor: aView [
	<gtView>
	
	^ aView list
		title: 'Messages';
		priority: 10;
		items: [ self messages ]
]

{ #category : #accessing }
GtLOpenAiCompletionsRequestEntity >> messages [
	^ (self rawData at: 'messages') collect: [ :each | GtLOpenAiMessagesEntity new rawData: each ]
]

{ #category : #accessing }
GtLOpenAiCompletionsRequestEntity >> model [
	^ self rawData at: 'model'
]

{ #category : #accessing }
GtLOpenAiCompletionsRequestEntity >> reasoningEffort [
	^ self rawData at: 'reasoning_effort'
]

{ #category : #accessing }
GtLOpenAiCompletionsRequestEntity >> stream [
	^ self rawData at: 'stream'
]

{ #category : #accessing }
GtLOpenAiCompletionsRequestEntity >> tools [
	^ (self rawData at: 'tools') collect: [ :each | GtLOllamaCompletionsToolCallEntity new rawData: each ]
]
