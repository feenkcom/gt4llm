Class {
	#name : #GtOpenAIChatCompletionChoice,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'logProbs',
		'finishReason',
		'index',
		'message'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIChatCompletionChoice class >> serializationProperties [
	^ {#finish_reason -> #finishReason.
		#index -> #index.
		#logprobs -> #logProbs.
		#message -> #message}
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> finishReason [
	^ finishReason
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> finishReason: anObject [
	finishReason := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> gtMessageFor: aView [
	<gtView>
	^ aView forward
		title: 'Message';
		priority: 1;
		object: [ self message ];
		view: #gtContentFor:
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> index [
	^ index
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> index: anObject [
	index := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> logProbs [
	^ logProbs
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> logProbs: anObject [
	logProbs := anObject
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> message [
	^ message
]

{ #category : #accessing }
GtOpenAIChatCompletionChoice >> message: anObject [
	message := GtOpenAIChatMessage from: anObject
]
