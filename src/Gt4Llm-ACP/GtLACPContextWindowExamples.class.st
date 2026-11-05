"
I exercise session context-window updates, replacement after compaction, unknown capacity and the Session view.
"
Class {
	#name : #GtLACPContextWindowExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPContextWindowExamples >> contextUsageCanDecrease [
	<gtExample>
	| session previous |
	session := self sessionWithContextWindow.
	previous := session contextWindow.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'usage_update'.
				'used' -> 12000.
				'size' -> 200000} asDictionary
		to: session.
	self assert: session contextWindow usedTokens equals: 12000.
	self assert: session contextWindow remainingTokens equals: 188000.
	self assert: session contextWindow usagePercentage equals: 6.0.
	self assert: previous usedTokens equals: 53000.
	self assert: session turns isEmpty.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> sessionViewBeforeUsage [
	<gtExample>
	| session scripter |
	session := self unreportedSession.
	scripter := BlScripter new
			extent: 1000 @ 500;
			model: session;
			element: ((session gtSessionFor: GtPhlowView empty) asElementDo: [ :element | element ]);
			yourself.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Context window';
				exists ].
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Not reported' printString;
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPContextWindowExamples >> sessionViewUpdates [
	<gtExample>
	| scripter |
	scripter := self sessionViewBeforeUsage.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'usage_update'.
								'used' -> 53000.
								'size' -> 200000} asDictionary
						to: scripter model ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: '53000 / 200000 tokens (26.5% used)';
				exists ].
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPExamples new
						sendUpdate: {'sessionUpdate' -> 'usage_update'.
								'used' -> 12000.
								'size' -> 200000} asDictionary
						to: scripter model ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: '12000 / 200000 tokens (6.0% used)';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPContextWindowExamples >> sessionWithContextWindow [
	<gtExample>
	| session |
	session := self unreportedSession.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'usage_update'.
				'used' -> 53000.
				'size' -> 200000} asDictionary
		to: session.
	self assert: session contextWindow usedTokens equals: 53000.
	self assert: session contextWindow totalTokens equals: 200000.
	self assert: session contextWindow remainingTokens equals: 147000.
	self assert: session contextWindow usagePercentage equals: 26.5.
	self
		assert: session contextWindow printString
		equals: '53000 / 200000 tokens (26.5% used)'.
	self assert: session turns isEmpty.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> unreportedSession [
	<gtExample>
	| session |
	session := GtLACPExamples new session.
	self assert: session contextWindow isNil.
	^ session
]

{ #category : #examples }
GtLACPContextWindowExamples >> zeroCapacity [
	<gtExample>
	| session |
	session := self unreportedSession.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'usage_update'.
				'used' -> 0.
				'size' -> 0} asDictionary
		to: session.
	self assert: session contextWindow usagePercentage isNil.
	self assert: session contextWindow printString equals: '0 / 0 tokens'.
	self assertObjectPhlowViewsFor: session contextWindow.
	^ session
]
