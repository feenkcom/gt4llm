Class {
	#name : #GtLOpenAICompactionStrategy,
	#superclass : #Object,
	#instVars : [
		'provider'
	],
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #'instance creation' }
GtLOpenAICompactionStrategy class >> forProvider: aProvider [ 
	^self new 
		provider: aProvider
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> provider [
	^provider
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> provider: anObject [
	provider := anObject
]
