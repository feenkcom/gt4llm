Class {
	#name : #GtLOpenAIMessageTokensData,
	#superclass : #GtLEntity,
	#instVars : [
		'inputTokens',
		'outputTokens'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #serialization }
GtLOpenAIMessageTokensData class >> serializationProperties [
	^ {
		#input_tokens -> #inputTokens.
		#output_tokens -> #outputTokens}
]

{ #category : #accessing }
GtLOpenAIMessageTokensData >> inputTokens [
	^inputTokens
]

{ #category : #accessing }
GtLOpenAIMessageTokensData >> inputTokens: anObject [
	inputTokens := anObject
]

{ #category : #accessing }
GtLOpenAIMessageTokensData >> outputTokens [
	^outputTokens
]

{ #category : #accessing }
GtLOpenAIMessageTokensData >> outputTokens: anObject [
	outputTokens := anObject
]
