"
Represents an assistant message entry from an Ollama-compatible completions response backed by raw JSON data.
"
Class {
	#name : #GtLOllamaCompletionsMessageEntity,
	#superclass : #GtLApiEntity,
	#category : #'Gt4LlmModel-ZnModel'
}

{ #category : #accessing }
GtLOllamaCompletionsMessageEntity >> content [
	^ self rawData at: 'content'
]

{ #category : #ui }
GtLOllamaCompletionsMessageEntity >> gtContentFor: aView [
	<gtView>
	
	^ aView text
		title: 'Content';
		priority: 10;
		text: [ self content ]
]

{ #category : #ui }
GtLOllamaCompletionsMessageEntity >> gtReasoningFor: aView [
	<gtView>
	
	^ aView text
		title: 'Reasoning';
		priority: 20;
		text: [ self reasoning ]
]

{ #category : #ui }
GtLOllamaCompletionsMessageEntity >> gtToolCallsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Tool Calls';
		priority: 30;
		items: [ self toolCalls ];
		column: 'Tool' text: [ :item | item gtDisplayString ]
]

{ #category : #accessing }
GtLOllamaCompletionsMessageEntity >> reasoning [
	^ self rawData at: 'reasoning'
]

{ #category : #accessing }
GtLOllamaCompletionsMessageEntity >> role [
	^ self rawData at: 'role'
]

{ #category : #accessing }
GtLOllamaCompletionsMessageEntity >> toolCalls [
	^ (self rawData at: 'tool_calls') collect: [ :each | GtLOllamaCompletionsToolCallEntity new rawData: each ]
]
