Class {
	#name : #GtLlmFeatures,
	#superclass : #Object,
	#classInstVars : [
		'UseCoder'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> initialize [
	UseCoder := false
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> setUseCoder: aBool [
	UseCoder := aBool
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> useCoder [
	UseCoder := true
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> usesCoder [
	^ UseCoder ifNil: [ false ]
]
