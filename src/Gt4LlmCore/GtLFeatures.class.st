Class {
	#name : #GtLFeatures,
	#superclass : #Object,
	#classInstVars : [
		'UseCoder'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #'as yet unclassified' }
GtLFeatures class >> disableInCoder [
	UseCoder := false
]

{ #category : #'as yet unclassified' }
GtLFeatures class >> enableInCoder [
	UseCoder := true
]

{ #category : #'as yet unclassified' }
GtLFeatures class >> initialize [
	UseCoder := false.
]

{ #category : #'as yet unclassified' }
GtLFeatures class >> isEnabledInCoder [
	^ UseCoder ifNil: [ UseCoder := false ]
]

{ #category : #'as yet unclassified' }
GtLFeatures class >> setEnableInCoder: aBool [
	UseCoder := aBool
]
