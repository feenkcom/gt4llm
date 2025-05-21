Class {
	#name : #GtLlmFeatures,
	#superclass : #Object,
	#classInstVars : [
		'UseCoder',
		'MultiStep'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> beExperimental [
	self useCoder useMultiStep
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> initialize [
	UseCoder := false
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> multiStep [
	^ MultiStep ifNil: [ false ]
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
GtLlmFeatures class >> useMultiStep [
	MultiStep := true
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> usesCoder [
	^ UseCoder ifNil: [ false ]
]
