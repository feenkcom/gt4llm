Class {
	#name : #GtLExampleComparisonWrappedString,
	#superclass : #Object,
	#instVars : [
		'targetString'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #accessing }
GtLExampleComparisonWrappedString >> printData [
	^ self targetString
]

{ #category : #accessing }
GtLExampleComparisonWrappedString >> targetString [
	^ targetString
]

{ #category : #accessing }
GtLExampleComparisonWrappedString >> targetString: anObject [
	targetString := anObject
]
