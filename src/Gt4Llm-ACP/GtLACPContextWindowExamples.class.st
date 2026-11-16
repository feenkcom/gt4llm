"
I provide the essential examples for ACP context: raw evidence and derivation, invalid reports, historical reception order, streaming, tool-only turns, replay, independent sessions, and numeric conversation-tree bars with missing values.
"
Class {
	#name : #GtLACPContextWindowExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPContextWindowExamples >> conversationTreeContextColumn [
	<gtExample>
	| session scripter view element cells |
	session := self receivedMessagesKeepContext.
	self assert: session asConversationTreeNode contextPercentage isNil.
	self
		assert: session currentTurn asConversationTreeNode contextPercentage
		equals: 6.0.
	view := (GtLACPSessionGroup withAll: {session})
			gtConversationTreeFor: GtPhlowView empty.
	self assert: (view columns fifth isKindOf: GtPhlowNumberColumn).
	element := (view
			expandAll;
			yourself)
			asElementDo: [ :widget | 
				widget
					background: Color white;
					yourself ].
	scripter := BlScripter new
			extent: 1600 @ 600;
			model: session;
			element: element;
			yourself.
	#('26.5%' '6.0%')
		do: [ :text | 
			scripter
				assertStep: [ :step | 
					step
						value: [ :root | 
							((root query // GtPhlowColumnDecorationElement) all
								collect: [ :cell | cell content text asString ]) includes: text ]
						equals: [ true ] ] ].
	cells := (scripter element query // GtPhlowColumnDecorationElement) all.
	self assert: cells size equals: 4.
	self
		assert: ((cells detect: [ :cell | cell content text asString = '26.5%' ]) fraction
				closeTo: 0.265).
	self
		assert: (cells detect: [ :cell | cell content text asString isEmpty ]) bar width
		equals: 0.
	scripter
		doStep: [ :step | 
			step
				block: [ self
						sendMessageText: ' continued'
						kind: 'agent_message_chunk'
						id: 'second'
						to: session ] ].
	scripter pulseUntilReady.
	#('26.5%' '9.0%')
		do: [ :text | 
			scripter
				assertStep: [ :step | 
					step
						value: [ :root | 
							((root query // GtPhlowColumnDecorationElement) all
								collect: [ :cell | cell content text asString ]) includes: text ]
						equals: [ true ] ] ].
	cells := (scripter element query // GtPhlowColumnDecorationElement) all.
	self
		assert: ((cells detect: [ :cell | cell content text asString = '9.0%' ]) fraction
				closeTo: 0.09).
	cells
		do: [ :cell | 
			self
				assert: (cell bar width
						closeTo: ((cell width * cell fraction) isZero
								ifTrue: [ 0 ]
								ifFalse: [ (cell width * cell fraction max: 2) min: cell width ])) ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPContextWindowExamples >> conversationTreeUnavailableContextBars [
	<gtExample>
	| session view scripter cells |
	session := GtLACPExamples new session.
	self
		sendMessageText: 'No usage reported'
		kind: 'agent_message_chunk'
		id: 'unreported'
		to: session.
	self assert: session currentTurn hasContextUsageUpdate not.
	self assert: session currentTurn messages first hasContextUsageUpdate not.
	self
		sendUsage: 0
		size: 200000
		to: session.
	self
		sendMessageText: 'Known zero usage'
		kind: 'agent_message_chunk'
		id: 'zero'
		to: session.
	self
		sendUsage: 100
		size: 0
		to: session.
	self
		sendMessageText: 'Unknown capacity'
		kind: 'agent_message_chunk'
		id: 'unknown-capacity'
		to: session.
	self assert: session contextWindow usagePercentageString equals: ''.
	self assert: session contextWindow printString equals: '100 / 0 tokens'.
	self assert: session currentTurn messages first hasContextUsageUpdate not.
	self assert: session currentTurn messages second hasContextUsageUpdate.
	self assert: session currentTurn messages last hasContextUsageUpdate.
	self assert: session currentTurn hasContextUsageUpdate.
	self assert: session currentTurn asConversationTreeNode contextPercentage isNil.
	self
		assert: session currentTurn messages first asConversationTreeNode contextPercentage
				isNil.
	self
		assert: session currentTurn messages second asConversationTreeNode contextPercentage
		equals: 0.0.
	self
		assert: session currentTurn messages last asConversationTreeNode contextPercentage isNil.
	view := ((GtLACPSessionGroup withAll: {session})
			gtConversationTreeFor: GtPhlowView empty)
			expandAll;
			yourself.
	scripter := BlScripter new
			extent: 1600 @ 600;
			model: session;
			element: (view
					asElementDo: [ :widget | 
						widget
							background: Color white;
							yourself ]);
			yourself.
	scripter
		assertStep: [ :step | 
			step
				value: [ :root | 
					((root query // GtPhlowColumnDecorationElement) all
						collect: [ :cell | cell content text asString ]) includes: '0.0%' ]
				equals: [ true ] ].
	cells := (scripter element query // GtPhlowColumnDecorationElement) all.
	self assert: cells size equals: 5.
	self
		assert: (cells count: [ :cell | cell content text asString isEmpty ])
		equals: 4.
	cells
		do: [ :cell | 
			self assert: cell fraction equals: 0.
			self assert: cell bar width equals: 0 ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPContextWindowExamples >> earlierTurnContextIsPreserved [
	<gtExample>
	| session earlier |
	session := self sessionWithContextWindow.
	session state: GtLACPSessionLoadingState new.
	self
		sendMessageText: 'First user'
		kind: 'user_message_chunk'
		id: 'first-user'
		to: session.
	self
		sendMessageText: 'First answer'
		kind: 'agent_message_chunk'
		id: 'first-answer'
		to: session.
	earlier := session currentTurn.
	self
		sendUsage: 12000
		size: 200000
		to: session.
	self
		sendMessageText: 'Second user'
		kind: 'user_message_chunk'
		id: 'second-user'
		to: session.
	self assert: session turns size equals: 2.
	self assert: session currentTurn isReplayed.
	self assert: earlier contextWindow usedTokens equals: 53000.
	self assert: session currentTurn contextWindow usedTokens equals: 12000.
	self
		sendUsage: 18000
		size: 200000
		to: session.
	self assert: session currentTurn contextWindow usedTokens equals: 12000.
	session state: GtLACPSessionReadyState new.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> malformedUsagePreservesLastValidContext [
	<gtExample>
	| session previous derived |
	session := GtLACPExamples new session.
	self malformedUsageUpdates
		do: [ :update | 
			GtLACPExamples new sendUpdate: update to: session.
			self assert: session contextWindow isReported not ].
	self
		sendUsage: 53000
		size: 200000
		to: session.
	previous := session latestContextUsageUpdate.
	derived := session contextWindow.
	self malformedUsageUpdates
		do: [ :update | 
			GtLACPExamples new sendUpdate: update to: session.
			self assert: session latestContextUsageUpdate == previous ].
	self assert: session contextWindow usedTokens equals: 53000.
	self
		sendUsage: 12000
		size: 200000
		to: session.
	self assert: session contextWindow usedTokens equals: 12000.
	self assert: session contextWindow remainingTokens equals: 188000.
	self assert: derived usedTokens equals: 53000.
	self assert: session turns isEmpty.
	^ session
]

{ #category : #helpers }
GtLACPContextWindowExamples >> malformedUsageUpdates [
	^ {#().
		{'used' -> 53000}.
		{'size' -> 200000}.
		{'used' -> nil.
			'size' -> 200000}.
		{'used' -> 53000.
			'size' -> nil}.
		{'used' -> '53000'.
			'size' -> 200000}.
		{'used' -> 53000.
			'size' -> '200000'}.
		{'used' -> -1.
			'size' -> 200000}.
		{'used' -> 53000.
			'size' -> -1}.
		{'used' -> 1.5.
			'size' -> 200000}.
		{'used' -> 53000.
			'size' -> 200000.5}.
		{'used' -> true.
			'size' -> 200000}.
		{'used' -> 53000.
			'size' -> false}}
		collect: [ :fields | 
			fields asDictionary
				at: 'sessionUpdate' put: 'usage_update';
				yourself ]
]

{ #category : #examples }
GtLACPContextWindowExamples >> mergedChunksCaptureLatestContext [
	<gtExample>
	| session message previous later |
	session := self sessionWithContextWindow.
	self
		sendMessageText: 'Hello'
		kind: 'agent_message_chunk'
		id: 'streamed'
		to: session.
	message := session currentTurn messages last.
	previous := message lastReceivedUpdate.
	self
		sendUsage: 54000
		size: 200000
		to: session.
	self assert: message contextWindow usedTokens equals: 53000.
	self
		sendMessageText: ' world'
		kind: 'agent_message_chunk'
		id: 'streamed'
		to: session.
	self assert: session currentTurn messages size equals: 1.
	self assert: session currentTurn messages last == message.
	self assert: message text equals: 'Hello world'.
	self assert: message contextWindow usedTokens equals: 54000.
	self assert: (previous contextUsageUpdate data at: 'used') equals: 53000.
	self
		sendMessageText: 'Later message'
		kind: 'agent_message_chunk'
		id: 'later'
		to: session.
	later := session currentTurn messages last.
	self
		sendUsage: 55000
		size: 200000
		to: session.
	self
		sendMessageText: ' continued'
		kind: 'agent_message_chunk'
		id: 'streamed'
		to: session.
	self assert: session currentTurn messages last == later.
	self assert: later contextWindow usedTokens equals: 54000.
	self assert: message contextWindow usedTokens equals: 55000.
	self assert: session currentTurn contextWindow usedTokens equals: 55000.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> receivedMessagesKeepContext [
	<gtExample>
	| session first second usage derived |
	session := self sessionWithContextWindow.
	usage := session latestContextUsageUpdate.
	self
		sendMessageText: 'First reply'
		kind: 'agent_message_chunk'
		id: 'first'
		to: session.
	first := session currentTurn messages last.
	self assert: first hasContextUsageUpdate.
	self assert: session currentTurn hasContextUsageUpdate.
	self assert: first contextUsageUpdate == usage.
	self assert: first lastReceivedUpdate == session updates last.
	self assert: session currentTurn lastReceivedUpdate == first lastReceivedUpdate.
	self
		sendUsage: 12000
		size: 200000
		to: session.
	self
		sendMessageText: 'After compaction'
		kind: 'agent_message_chunk'
		id: 'second'
		to: session.
	second := session currentTurn messages last.
	self
		sendUsage: 18000
		size: 200000
		to: session.
	self assert: first contextWindow usedTokens equals: 53000.
	self assert: second contextWindow usedTokens equals: 12000.
	self assert: session currentTurn contextWindow usedTokens equals: 12000.
	self assert: session contextWindow usedTokens equals: 18000.
	derived := session currentTurn contextWindow.
	derived
		updateFrom: {'used' -> 1.
				'size' -> 2} asDictionary.
	self assert: session currentTurn contextWindow usedTokens equals: 12000.
	self assert: session contextWindow usedTokens equals: 18000.
	self assert: (second contextUsageUpdate data at: 'used') equals: 12000.
	^ session
]

{ #category : #helpers }
GtLACPContextWindowExamples >> sendMessageText: text kind: kind id: anId to: aSession [
	| update |
	update := {'sessionUpdate' -> kind.
			'content'
				-> {'type' -> 'text'.
						'text' -> text} asDictionary} asDictionary.
	anId ifNotNil: [ update at: 'messageId' put: anId ].
	GtLACPExamples new sendUpdate: update to: aSession
]

{ #category : #helpers }
GtLACPContextWindowExamples >> sendUsage: used size: size to: aSession [
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'usage_update'.
				'used' -> used.
				'size' -> size} asDictionary
		to: aSession
]

{ #category : #examples }
GtLACPContextWindowExamples >> sessionWithContextWindow [
	<gtExample>
	| session update |
	session := GtLACPExamples new session.
	self assert: session contextWindow isReported not.
	self assert: session contextWindow usagePercentageString equals: ''.
	update := {'sessionUpdate' -> 'usage_update'.
			'used' -> 53000.
			'size' -> 200000} asDictionary.
	session receiveUpdate: update.
	update at: 'used' put: 1.
	self assert: (session latestContextUsageUpdate data at: 'used') equals: 53000.
	self
		assert: session latestContextUsageUpdate contextWindow usedTokens
		equals: 53000.
	self assert: session contextWindow usedTokens equals: 53000.
	self assert: session contextWindow totalTokens equals: 200000.
	self assert: session contextWindow remainingTokens equals: 147000.
	self assert: session contextWindow usagePercentage equals: 26.5.
	self assert: session contextWindow usagePercentageString equals: '26.5%'.
	self
		assert: session contextWindow printString
		equals: '53000 / 200000 tokens (26.5% used)'.
	self assert: session turns isEmpty.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> subagentMessageContextIsIndependent [
	<gtExample>
	| root child sibling |
	root := self sessionWithContextWindow.
	child := GtLACPSubagentExamples new
			announce: 'context-child'
			title: 'Context child'
			in: root.
	sibling := GtLACPSubagentExamples new
			announce: 'context-sibling'
			title: 'Context sibling'
			in: root.
	self
		sendUsage: 100
		size: 1000
		to: child.
	self
		sendMessageText: 'Child reply'
		kind: 'agent_message_chunk'
		id: 'child-reply'
		to: child.
	self
		sendMessageText: 'Sibling reply'
		kind: 'agent_message_chunk'
		id: 'sibling-reply'
		to: sibling.
	self
		sendUsage: 200
		size: 1000
		to: child.
	self assert: child currentTurn contextWindow usedTokens equals: 100.
	self
		assert: child currentTurn messages last contextWindow usedTokens
		equals: 100.
	self assert: sibling currentTurn contextWindow isReported not.
	self assert: root contextWindow usedTokens equals: 53000.
	^ root
]

{ #category : #examples }
GtLACPContextWindowExamples >> toolUpdatesCaptureTurnContext [
	<gtExample>
	| session turn |
	self assert: GtLACPPromptTurn new hasContextUsageUpdate not.
	session := self sessionWithContextWindow.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'context-tool'.
				'title' -> 'Read context'.
				'status' -> 'in_progress'} asDictionary
		to: session.
	turn := session currentTurn.
	self assert: turn hasContextUsageUpdate.
	self assert: turn messages isEmpty.
	self assert: turn contextWindow usedTokens equals: 53000.
	self
		sendUsage: 12000
		size: 200000
		to: session.
	self assert: turn contextWindow usedTokens equals: 53000.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'tool_call_update'.
				'toolCallId' -> 'context-tool'.
				'status' -> 'completed'} asDictionary
		to: session.
	self assert: turn contextWindow usedTokens equals: 12000.
	self assert: turn lastReceivedUpdate == session updates last.
	self
		assert: turn lastReceivedUpdate contextUsageUpdate == session latestContextUsageUpdate.
	^ turn
]
