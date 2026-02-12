Class {
	#name : #GtLMessageTokensData,
	#superclass : #GtLEntity,
	#instVars : [
		'inputTokens',
		'outputTokens'
	],
	#category : #Gt4LlmCore
}

{ #category : #serialization }
GtLMessageTokensData class >> serializationProperties [
	^ {
		#input_tokens -> #inputTokens.
		#output_tokens -> #outputTokens}
]

{ #category : #accessing }
GtLMessageTokensData >> inputTokens [
	^inputTokens
]

{ #category : #accessing }
GtLMessageTokensData >> inputTokens: anObject [
	inputTokens := anObject
]

{ #category : #accessing }
GtLMessageTokensData >> outputTokens [
	^outputTokens
]

{ #category : #accessing }
GtLMessageTokensData >> outputTokens: anObject [
	outputTokens := anObject
]
