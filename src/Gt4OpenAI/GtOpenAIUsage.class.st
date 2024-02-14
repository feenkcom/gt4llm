Class {
	#name : #GtOpenAIUsage,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'promptTokens',
		'completionTokens',
		'totalTokens'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIUsage class >> serializationProperties [
	^ {#completion_tokens -> #completionTokens.
		#prompt_tokens -> #promptTokens.
		#total_tokens -> #totalTokens}
]

{ #category : #accessing }
GtOpenAIUsage >> completionTokens [
	^ completionTokens
]

{ #category : #accessing }
GtOpenAIUsage >> completionTokens: anObject [
	completionTokens := anObject
]

{ #category : #accessing }
GtOpenAIUsage >> promptTokens [
	^ promptTokens
]

{ #category : #accessing }
GtOpenAIUsage >> promptTokens: anObject [
	promptTokens := anObject
]

{ #category : #accessing }
GtOpenAIUsage >> totalTokens [
	^ totalTokens
]

{ #category : #accessing }
GtOpenAIUsage >> totalTokens: anObject [
	totalTokens := anObject
]
