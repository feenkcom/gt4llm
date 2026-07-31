Class {
	#name : #GtLCompactionStrategy,
	#superclass : #Object,
	#instVars : [
		'provider',
		'compactionCondition'
	],
	#category : #'Gt4LlmCore-Compaction'
}

{ #category : #'instance creation' }
GtLCompactionStrategy class >> forProvider: aProvider [ 
	^self new 
		provider: aProvider
]

{ #category : #'api - compaction' }
GtLCompactionStrategy >> addConfigurationTo: entity for: chat [
	"Subclasses that require additional entity entries will overwrite"
]

{ #category : #accessing }
GtLCompactionStrategy >> compactionThreshold [
	^compactionCondition
]

{ #category : #accessing }
GtLCompactionStrategy >> compactionThreshold: aCompactionTreshold [
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

{ #category : #testing }
GtLCompactionStrategy >> isNoCompaction [

	^ false
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
GtLCompactionStrategy >> relevantChatMessagesFor: aChat [
	| relevantMessages |
	relevantMessages := aChat messages
			messagesSelect: [:each | each isAssistantRole and: [each hasCompactionResponse]].
	^relevantMessages isEmpty
		ifTrue: [aChat messages]
		ifFalse: [
			aChat messages 
				messagesBeforeMatching: [:each | each isUserRole]
				andAllWithAndAfter: relevantMessages last]
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
