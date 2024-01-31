Class {
	#name : #Gt4OpenAIChatCompletionChoice,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'logProbs',
		'finishReason',
		'index',
		'message'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice class >> serializationProperties [
	^ {#finish_reason -> #finishReason.
		#index -> #index.
		#logprobs -> #logProbs.
		#message -> #message}
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> finishReason [
	^ finishReason
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> finishReason: anObject [
	finishReason := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> gtMessageFor: aView [
	<gtView>
	^ aView forward
		title: 'Message';
		priority: 1;
		object: [ self message ];
		view: #gtContentFor:
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> index [
	^ index
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> index: anObject [
	index := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> logProbs [
	^ logProbs
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> logProbs: anObject [
	logProbs := anObject
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> message [
	^ message
]

{ #category : #accessing }
Gt4OpenAIChatCompletionChoice >> message: anObject [
	message := Gt4OpenAIChatMessage from: anObject
]
