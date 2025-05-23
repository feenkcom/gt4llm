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
	self enableInCoder useMultiStep
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> disableInCoder [
	UseCoder := false
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> enableInCoder [
	UseCoder := true
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> initialize [
	UseCoder := true.
	MultiStep := false
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> isEnabledInCoder [
	^ UseCoder ifNil: [ UseCoder := true ]
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> multiStep [
	^ MultiStep ifNil: [ false ]
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> setEnableInCoder: aBool [
	UseCoder := aBool
]

{ #category : #'as yet unclassified' }
GtLlmFeatures class >> useMultiStep [
	MultiStep := true
]
