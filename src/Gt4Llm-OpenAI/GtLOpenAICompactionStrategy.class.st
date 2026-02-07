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

{ #category : #'api - compaction' }
GtLOpenAICompactionStrategy >> executeCompaction [
	self subclassResponsibility
]

{ #category : #testing }
GtLOpenAICompactionStrategy >> isCompactionNeeded [
	^self latestInputTokensCount > self thresholdTokensLimit
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> latestInputTokensCount [
	^ self latestTokensUsage
		ifNil: [0] 
		ifNotNil:[ :each | each inputTokens ]
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> latestTokensUsage [
	^ provider chat messages lastExecutedMessage
			ifNotNil: [ :aMessage |
				aMessage requestResponse resultOpenAIUsageDetails ]
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> provider [
	^provider
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> provider: anObject [
	provider := anObject
]

{ #category : #'api - compaction' }
GtLOpenAICompactionStrategy >> requestCompactionIfNeeded [
	self isCompactionNeeded ifTrue: [
		self executeCompaction ]
]

{ #category : #accessing }
GtLOpenAICompactionStrategy >> thresholdTokensLimit [
	^ 200000
]
