Class {
	#name : #GtLCompactionStrategy,
	#superclass : #Object,
	#instVars : [
		'provider',
		'compactionCondition'
	],
	#category : 'Gt4LlmCore-Compaction'
}

{ #category : #'instance creation' }
GtLCompactionStrategy class >> forProvider: aProvider [ 
	^self new 
		provider: aProvider
]

{ #category : #accessing }
GtLCompactionStrategy >> compactionTreshold [
	^compactionCondition
]

{ #category : #accessing }
GtLCompactionStrategy >> compactionTreshold: aCompactionTreshold [
	compactionCondition := aCompactionTreshold
]

{ #category : #'api - compaction' }
GtLCompactionStrategy >> executeCompaction [
	self subclassResponsibility
]

{ #category : #testing }
GtLCompactionStrategy >> isCompactionNeeded [
	^compactionCondition
		 aboveTokenCount: self latestInputTokensCount 
		 forProvider: self provider 
]

{ #category : #accessing }
GtLCompactionStrategy >> latestInputTokensCount [
	^ self latestTokensUsage
		ifNil: [0] 
		ifNotNil:[ :each | each inputTokens ]
]

{ #category : #accessing }
GtLCompactionStrategy >> latestTokensUsage [
	^ provider chat messages lastExecutedMessage
			ifNotNil: [ :aMessage |
				aMessage requestResponse resultUsageDetails ]
]

{ #category : #accessing }
GtLCompactionStrategy >> provider [
	^provider
]

{ #category : #accessing }
GtLCompactionStrategy >> provider: anObject [
	provider := anObject
]

{ #category : #'api - compaction' }
GtLCompactionStrategy >> requestCompactionIfNeeded [
	self isCompactionNeeded ifTrue: [
		self executeCompaction ]
]

{ #category : #accessing }
GtLCompactionStrategy >> thresholdTokensLimit: anInteger [
	compactionCondition := GtLCompactionFixedThresholdCondition new 
		tokensLimit: anInteger
]
