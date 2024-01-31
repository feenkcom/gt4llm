Class {
	#name : #Gt4OpenAIUsage,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'promptTokens',
		'completionTokens',
		'totalTokens'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIUsage class >> serializationProperties [
	^ {#completion_tokens -> #completionTokens.
		#prompt_tokens -> #promptTokens.
		#total_tokens -> #totalTokens}
]

{ #category : #accessing }
Gt4OpenAIUsage >> completionTokens [
	^ completionTokens
]

{ #category : #accessing }
Gt4OpenAIUsage >> completionTokens: anObject [
	completionTokens := anObject
]

{ #category : #accessing }
Gt4OpenAIUsage >> promptTokens [
	^ promptTokens
]

{ #category : #accessing }
Gt4OpenAIUsage >> promptTokens: anObject [
	promptTokens := anObject
]

{ #category : #accessing }
Gt4OpenAIUsage >> totalTokens [
	^ totalTokens
]

{ #category : #accessing }
Gt4OpenAIUsage >> totalTokens: anObject [
	totalTokens := anObject
]
