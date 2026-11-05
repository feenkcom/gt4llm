"
I exercise amber attention indicators, notification navigation and resolution in root and nested ACP sessions.
"
Class {
	#name : #GtLACPAttentionScripterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPAttentionScripterExamples >> nestedAttentionInSessionTool [
	<gtExample>
	| context root child request scripter tool |
	context := GtLACPAttentionExamples new nestedContext.
	root := context at: 'session'.
	child := context at: 'child'.
	request := context at: 'request'.
	tool := GtLACPSessionToolElement new
			chat: root;
			yourself.
	scripter := BlScripter new
			extent: 1200 @ 1000;
			model: context;
			element: tool;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-input-needed';
				satisfies: [ :element | element visibility isVisible ] ].
	scripter click
		id: ('acp-agent-toggle-' , child currentTurn identityHash asString) asSymbol;
		play.
	scripter
		assertStep: [ :step | 
			step
				id: ('acp-agent-input-needed-' , child currentTurn identityHash asString) asSymbol;
				satisfies: [ :element | element visibility isVisible ] ].
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: ('acp-work-input-needed-' , root currentTurn identityHash asString) asSymbol;
				satisfies: [ :element | element visibility isVisible ] ].
	scripter doStep: [ :step | step block: [ request decline ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'prompting' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-message-input-needed';
				satisfies: [ :element | element visibility isGone ] ].
	self assert: (context at: 'notifications') size equals: 0.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> notificationDisplayed [
	<gtExample>
	| context notification scripter |
	context := GtLACPAttentionExamples new nestedContext.
	notification := (context at: 'request') inputNotification.
	scripter := BlScripter new
			extent: 700 @ 300;
			model: context;
			element: notification asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-input-notification-inspect';
				exists ].
	self assert: (notification message beginsWith: 'Input needed').
	self assert: (context at: 'notifications') size equals: 1.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> notificationOpensNestedInteraction [
	<gtExample>
	| context root request notification scripter |
	context := GtLACPAttentionExamples new nestedContext.
	root := context at: 'session'.
	request := context at: 'request'.
	GtLACPExamples new
		sendUpdate: {'sessionUpdate' -> 'agent_thought_chunk'.
				'content'
					-> {'type' -> 'text'.
							'text'
								-> (String
										streamContents: [ :stream | 
											1
												to: 80
												do: [ :index | 
													stream
														nextPutAll: 'Prior work ';
														print: index;
														cr ] ])} asDictionary} asDictionary
		to: root.
	notification := request inputNotification.
	scripter := BlScripter new
			extent: 1800 @ 1100;
			model: context;
			element: (GtPagerSettings usedPager
					createWrappedOn: (GtInspector forObject: notification asElement));
			yourself.
	scripter click
		id: #'acp-input-notification-inspect';
		play.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				// GtLACPSessionToolElement;
				satisfies: [ :element | element chat == root ] ].
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: request interactionElementId;
				exists ].
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: #'acp-work-section';
				satisfies: #isExpanded ].
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				// GtLACPChatElement;
				satisfies: [ :chat | 
					| target |
					chat
						withAllChildrenBreadthFirstDo: [ :each | each id asSymbol = request interactionElementId ifTrue: [ target := each ] ].
					target notNil
						and: [ target bounds inSpace top >= chat messageViewport bounds inSpace top
								and: [ target bounds inSpace top < (chat messageViewport bounds inSpace bottom - 40) ] ] ] ].
	self assert: (context at: 'notifications') size equals: 1.
	self assert: request state equals: #pending.
	scripter
		clickStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: #'acp-question-question_0-option-1' ].
	scripter
		clickStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: #'acp-question-submit' ].
	scripter pulseUntilReady.
	self assert: request state equals: #accept.
	self assert: (context at: 'notifications') size equals: 0.
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'prompting' ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> registryDisplaysInputNeeded [
	<gtExample>
	| context registry root request scripter |
	context := GtLACPAttentionExamples new nestedContext.
	root := context at: 'session'.
	request := context at: 'request'.
	registry := GtLACPSessionRegistry new.
	registry registerSession: root.
	scripter := BlScripter new
			extent: 1200 @ 800;
			model: context;
			element: (GtLACPSessionRegistryToolElement new
					registry: registry;
					yourself);
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed' ] ].
	self
		assert: (registry sessionsByState
				anySatisfy: [ :entry | entry key = #inputNeeded and: [ entry value includes: root ] ]).
	scripter doStep: [ :step | step block: [ request decline ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'prompting' ] ].
	self
		assert: (registry sessionsByState noneSatisfy: [ :entry | entry key = #inputNeeded ]).
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> registryWithTwoPendingInteractions [
	<gtExample>
	| context root registry scripter |
	context := self twoPendingInteractionsInSessionTool model.
	root := context at: 'session'.
	registry := GtLACPSessionRegistry new.
	registry registerSession: root.
	context at: 'registry' put: registry.
	scripter := BlScripter new
			extent: 2000 @ 1100;
			model: context;
			element: (GtPagerSettings usedPager
					createWrappedOn: (GtLACPSessionRegistryTool forRegistry: registry));
			yourself.
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 1;
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed · 2' ] ].
	scripter
		clickStep: [ :step | 
			step
				onPagerPaneWithIndex: 1;
				id: #'acp-session-state-marker' ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				// GtLACPSessionToolElement;
				satisfies: [ :element | element chat == root ] ].
	scripter
		assertStep: [ :step | 
			step
				onPagerPaneWithIndex: 2;
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed · 2' ] ].
	self assert: root pendingInteractions size equals: 2.
	self assert: (context at: 'notifications') size equals: 2.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> sessionBadgeAfterAllInteractionsResolved [
	<gtExample>
	| scripter session |
	scripter := self sessionBadgeWithRemainingPermission.
	session := scripter model at: 'session'.
	scripter
		doStep: [ :step | step block: [ session currentTurn permissionRequests first resolve: 'allow' ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'prompting' ] ].
	self assert: (scripter model at: 'notifications') size equals: 0.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> sessionBadgeWhilePrompting [
	<gtExample>
	| context session scripter |
	context := GtLACPAttentionExamples new context.
	session := context at: 'session'.
	session prompt: 'Ask for input'.
	scripter := BlScripter new
			extent: 400 @ 100;
			model: context;
			element: (GtLACPSessionStateElement new
					session: session;
					yourself);
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'prompting' ] ].
	self assert: (context at: 'notifications') size equals: 0.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> sessionBadgeWithPendingQuestion [
	<gtExample>
	| scripter session examples |
	scripter := self sessionBadgeWhilePrompting.
	session := scripter model at: 'session'.
	examples := GtLACPElicitationExamples new.
	scripter
		doStep: [ :step | 
			step
				block: [ examples
						receive: (examples questionParametersFor: session)
						id: 'badge-question'
						in: session ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed' ] ].
	self
		assert: scripter element stateColor
		equals: GtLACPInputNeededElement amberColor.
	self assert: (scripter model at: 'notifications') size equals: 1.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> sessionBadgeWithRemainingPermission [
	<gtExample>
	| scripter session |
	scripter := self sessionBadgeWithTwoPendingInteractions.
	session := scripter model at: 'session'.
	scripter
		doStep: [ :step | step block: [ session currentTurn elicitationRequests first decline ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed' ] ].
	self assert: (scripter model at: 'notifications') size equals: 1.
	self
		assert: (scripter model at: 'notifications') asArray first request
				== session currentTurn permissionRequests first.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> sessionBadgeWithTwoPendingInteractions [
	<gtExample>
	| scripter session |
	scripter := self sessionBadgeWithPendingQuestion.
	session := scripter model at: 'session'.
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPPermissionScripterExamples new
						receivePermissionIn: session
						requestId: 'badge-permission' ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed · 2' ] ].
	self assert: (scripter model at: 'notifications') size equals: 2.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPAttentionScripterExamples >> twoPendingInteractionsInSessionTool [
	<gtExample>
	| context root scripter |
	context := GtLACPAttentionExamples new nestedContext.
	root := context at: 'session'.
	GtLACPPermissionScripterExamples new
		receivePermissionIn: root
		requestId: 'root-attention-permission'.
	scripter := BlScripter new
			extent: 1200 @ 1100;
			model: context;
			element: (GtLACPSessionToolElement new
					chat: root;
					yourself);
			yourself.
	self assert: root pendingInteractions size equals: 2.
	self assert: (context at: 'notifications') size equals: 2.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-session-state-label';
				value: [ :label | label text asString ] equals: [ 'input needed · 2' ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
