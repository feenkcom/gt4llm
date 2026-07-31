Class {
	#name : #GtLOpenAiServerSideCompactionStrategy,
	#superclass : #GtLCompactionStrategy,
	#category : #'Gt4LlmCore-Compaction'
}

{ #category : #'api - compaction' }
GtLOpenAiServerSideCompactionStrategy >> addConfigurationTo: entity for: chat [
	"Set the OpenAI server-side compaction threshold.
	See https://developers.openai.com/api/docs/guides/compaction"
	
	entity at: 'context_management' put: { {
			'type' -> 'compaction'.
			'compact_threshold' -> compactionCondition tokensLimit
			} asDictionary }.
]

{ #category : #'api - compaction' }
GtLOpenAiServerSideCompactionStrategy >> executeCompaction [

	self error: 'OpenAI server-side compaction doesn''t use compaction messages'.
]

{ #category : #'private - testing' }
GtLOpenAiServerSideCompactionStrategy >> hasCompactionResponse: aMessage [

	^ aMessage isAssistantRole and:
		[ | response |
		response := aMessage requestResponse result.
		response output anySatisfy: [ :jsonObject |
			(jsonObject at: 'type' ifAbsent: []) = 'compaction' ] ].
]

{ #category : #testing }
GtLOpenAiServerSideCompactionStrategy >> isCompactionNeeded [
	"Answer a boolean if a compaction message should be sent.
	OpenAI server-side compaction is automatic, no message needed."
	
	^ false
]

{ #category : #'api - compaction' }
GtLOpenAiServerSideCompactionStrategy >> relevantChatMessagesFor: aChat [
	"The OpenAI documentation is a little unclear about which messages to include.
	Currently including the latest compaction output and all following messages."
	| relevantMessages |
	
	relevantMessages := aChat messages messagesSelect: 
		[ :each | self hasCompactionResponse: each ].
	^relevantMessages isEmpty
		ifTrue: [aChat messages]
		ifFalse: [
			aChat messages 
				messagesBeforeMatching: [:each | false ]
				andAllWithAndAfter: relevantMessages last]
]
