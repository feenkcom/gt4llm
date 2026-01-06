Class {
	#name : #GtLOpenAIChatCompletionChoice,
	#superclass : #GtLEntity,
	#instVars : [
		'logProbs',
		'finishReason',
		'index',
		'message'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIChatCompletionChoice class >> serializationProperties [
	^ {#finish_reason -> #finishReason.
		#index -> #index.
		#logprobs -> #logProbs.
		#message -> #message}
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> finishReason [
	^ finishReason
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> finishReason: anObject [
	finishReason := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> gtMessageFor: aView [
	<gtView>
	^ aView forward
		title: 'Message';
		priority: 1;
		object: [ self message ];
		view: #gtContentFor:
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> index [
	^ index
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> index: anObject [
	index := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> logProbs [
	^ logProbs
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> logProbs: anObject [
	logProbs := anObject
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> message [
	^ message
]

{ #category : #accessing }
GtLOpenAIChatCompletionChoice >> message: anObject [
	message := GtLlmChatMessage from: anObject
]
