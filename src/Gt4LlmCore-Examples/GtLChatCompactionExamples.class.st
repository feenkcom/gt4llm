Class {
	#name : #GtLChatCompactionExamples,
	#superclass : #Object,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#category : #'Gt4LlmCore-Examples-Compaction'
}

{ #category : #examples }
GtLChatCompactionExamples >> addingAssistantMessageDoesNotPurgeObjectStorage [
	<gtExample>
	<return: #GtLChat>
	| chat objectId |

	chat := GtLChat new.
	objectId := chat
		addNewObject: Object new
		reasonString: 'Object remains before compaction'.

	chat addAssistantMessage: GtLModelAssistantMessage new.

	self assert: chat objectStorage objectCount equals: 1.
	self assert: (chat objectStorage includesObjectWithId: objectId).

	^ chat
]

{ #category : #examples }
GtLChatCompactionExamples >> addingCompactionMessagePurgesObjectStorage [
	<gtExample>
	<return: #GtLChat>
	| chat objectId compactionMessage replyMessage |

	chat := GtLChat new.
	objectId := chat
		addNewObject: Object new
		reasonString: 'Object made redundant by compaction'.
	self assert: chat objectStorage objectCount equals: 1.

	compactionMessage := GtLModelCompactionMessage new.
	chat addCompactionMessage: compactionMessage.

	self assert: chat objectStorage objectCount equals: 0.
	self deny: (chat objectStorage includesObjectWithId: objectId).
	self assert: compactionMessage chat == chat.

	replyMessage := chat messages last.
	self assert: replyMessage isReplyMessage.
	self assert: (replyMessage executionMessages includes: compactionMessage).

	^ chat
]
