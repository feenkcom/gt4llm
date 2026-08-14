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

{ #category : #accessing }
GtLOpenAiServerSideCompactionStrategy >> relevantChatMessagesFor: aChat [
	"Only a compaction reusable by this provider may become a history boundary.
	Incompatible opaque compactions are omitted while the earlier source history
	remains available."

	| serializableMessages compactionMessages |
	serializableMessages := aChat messages messagesSelect: [ :each |
		each isCompactionMessage
			ifTrue: [
				(each respondsTo: #canSerializeFor:)
					ifTrue: [ each canSerializeFor: self provider ]
					ifFalse: [ false ] ]
			ifFalse: [ true ] ].
	compactionMessages := serializableMessages messagesSelect: [ :each |
		each isCompactionMessage ].
	compactionMessages ifEmpty: [ ^ serializableMessages ].
	^ serializableMessages messagesWithAndAfter: compactionMessages last
]
