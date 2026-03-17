Class {
	#name : #GtLCompactionFixedThresholdCondition,
	#superclass : #GtLCompactionThresholdCondition,
	#instVars : [
		'tokensLimit'
	],
	#category : 'Gt4LlmCore-Compaction'
}

{ #category : #testing }
GtLCompactionFixedThresholdCondition >> aboveTokenCount: aTokenCount  forProvider: aProvider [ 	
	^ aTokenCount > self tokensLimit
]

{ #category : #accessing }
GtLCompactionFixedThresholdCondition >> tokensLimit [
	^tokensLimit
]

{ #category : #accessing }
GtLCompactionFixedThresholdCondition >> tokensLimit: anInteger [
	tokensLimit := anInteger
]
