Class {
	#name : #GtLOpenAIUsage,
	#superclass : #GtLEntity,
	#instVars : [
		'promptTokens',
		'completionTokens',
		'totalTokens'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIUsage class >> serializationProperties [
	^ {#completion_tokens -> #completionTokens.
		#prompt_tokens -> #promptTokens.
		#total_tokens -> #totalTokens}
]

{ #category : #accessing }
GtLOpenAIUsage >> completionTokens [
	^ completionTokens
]

{ #category : #accessing }
GtLOpenAIUsage >> completionTokens: anObject [
	completionTokens := anObject
]

{ #category : #accessing }
GtLOpenAIUsage >> promptTokens [
	^ promptTokens
]

{ #category : #accessing }
GtLOpenAIUsage >> promptTokens: anObject [
	promptTokens := anObject
]

{ #category : #accessing }
GtLOpenAIUsage >> totalTokens [
	^ totalTokens
]

{ #category : #accessing }
GtLOpenAIUsage >> totalTokens: anObject [
	totalTokens := anObject
]
