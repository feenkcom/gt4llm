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

{ #category : #testing }
GtLOpenAiServerSideCompactionStrategy >> isCompactionNeeded [
	"Answer a boolean if a compaction message should be sent.
	OpenAI server-side compaction is automatic, no message needed."
	
	^ false
]

{ #category : #'api - compaction' }
GtLOpenAiServerSideCompactionStrategy >> relevantChatMessagesFor: aChat [
	"Include the latest first-class compaction message and all flattened
	messages following it. If there is no compaction, include all messages."
	| compactionMessages |

	compactionMessages := aChat messages messagesSelect: [ :each |
		each isCompactionMessage ].

	compactionMessages ifEmpty: [ ^ aChat messages ].

	^ aChat messages messagesWithAndAfter: compactionMessages last
]
