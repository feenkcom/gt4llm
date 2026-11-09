"
Examples of chat identity derived from its first message.
"
Class {
	#name : #GtLChatExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLChatExamples >> emptyChatUid [
	<gtExample>
	| chat |
	chat := GtLChat new.
	self assert: chat uid isNil.
	^ chat
]

{ #category : #examples }
GtLChatExamples >> uidIsFirstMessageId [
	<gtExample>
	| chat first |
	chat := self emptyChatUid.
	first := GtLModelUserMessage new string: 'first'.
	chat addMessage: first.
	self assert: chat uid equals: first id.
	self assert: chat uid isNotNil.
	chat addMessage: (GtLModelUserMessage new string: 'second').
	self assert: chat uid equals: first id.
	chat resetMessages.
	self assert: chat uid isNil.
	^ chat
]
