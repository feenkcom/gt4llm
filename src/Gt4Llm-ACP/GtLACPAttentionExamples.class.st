"
I exercise derived input-needed state, notification identity and lifecycle using isolated notification collections.
"
Class {
	#name : #GtLACPAttentionExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPAttentionExamples >> closingAndDisconnectRemoveNotification [
	<gtExample>
	| context |
	context := self questionContext.
	(context at: 'session') close.
	self assert: (context at: 'notifications') size equals: 0.
	self assert: (context at: 'session') presentationState equals: #closed.
	context := self permissionContext.
	(context at: 'session') connectionClosed: 'Test disconnect'.
	self assert: (context at: 'notifications') size equals: 0.
	self assert: (context at: 'session') presentationState equals: #failed.
	^ context
]

{ #category : #fixtures }
GtLACPAttentionExamples >> context [
	| session notifications |
	session := GtLACPExamples new session.
	notifications := GtNotifications new.
	session connection
		notificationPublisher: [ :notification | notifications addNotification: notification ].
	^ {'session' -> session.
		'notifications' -> notifications} asDictionary
]

{ #category : #examples }
GtLACPAttentionExamples >> dismissDoesNotResolve [
	<gtExample>
	| context request |
	context := self questionContext.
	request := context at: 'request'.
	request inputNotification requestRemoval.
	self assert: (context at: 'notifications') size equals: 0.
	self assert: request state equals: #pending.
	self assert: request session presentationState equals: #inputNeeded.
	request session announceChanged.
	self assert: (context at: 'notifications') size equals: 0.
	request decline.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> duplicatePermissionDoesNotNotifyTwice [
	<gtExample>
	| context root request |
	context := self permissionContext.
	root := context at: 'session'.
	request := context at: 'request'.
	GtLACPPermissionScripterExamples new
		receivePermissionIn: root
		requestId: request requestId.
	self assert: root currentTurn permissionRequests size equals: 1.
	self assert: (context at: 'notifications') size equals: 1.
	self assert: root currentTurn permissionRequests first == request.
	request cancel.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> localAnswerRemovesNotification [
	<gtExample>
	| context request session notifications |
	context := self questionContext.
	request := context at: 'request'.
	session := context at: 'session'.
	notifications := context at: 'notifications'.
	self assert: session isPrompting.
	self assert: session presentationState equals: #inputNeeded.
	self assert: notifications size equals: 1.
	self assert: notifications asArray first == request inputNotification.
	5
		timesRepeat: [ request publishInputNeededNotification.
			session announceChanged ].
	self assert: notifications size equals: 1.
	request
		answerAt: 'question_0' put: 'Cards';
		submit.
	self assert: notifications size equals: 0.
	self assert: session presentationState equals: #prompting.
	self assert: session isPrompting.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> multipleRequestsResolveIndependently [
	<gtExample>
	| context root question permission |
	context := self nestedContext.
	root := context at: 'session'.
	question := context at: 'request'.
	GtLACPPermissionScripterExamples new
		receivePermissionIn: root
		requestId: 'root-attention-permission'.
	permission := root currentTurn permissionRequests first.
	self assert: root pendingInteractions size equals: 2.
	self assert: (context at: 'notifications') size equals: 2.
	question decline.
	self assert: root pendingInteractions size equals: 1.
	self assert: root presentationState equals: #inputNeeded.
	self
		assert: (context at: 'notifications') asArray first == permission inputNotification.
	permission resolve: 'deny'.
	self assert: root pendingInteractions isEmpty.
	self assert: (context at: 'notifications') size equals: 0.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> nestedAttentionPropagatesOnce [
	<gtExample>
	| context root child grandchild request |
	context := self nestedContext.
	root := context at: 'session'.
	child := context at: 'child'.
	grandchild := context at: 'grandchild'.
	request := context at: 'request'.
	{root.
		child.
		grandchild}
		do: [ :session | 
			self assert: session presentationState equals: #inputNeeded.
			self assert: session pendingInteractions size equals: 1.
			self assert: session pendingInteractions first == request ].
	root announceChanged.
	child announceChanged.
	self assert: (context at: 'notifications') size equals: 1.
	self assert: (request inputNotification message includesSubstring: 'Designer').
	request decline.
	{root.
		child.
		grandchild}
		do: [ :session | 
			self assert: session pendingInteractions isEmpty.
			self assert: session presentationState ~= #inputNeeded ].
	self assert: (context at: 'notifications') size equals: 0.
	^ context
]

{ #category : #fixtures }
GtLACPAttentionExamples >> nestedContext [
	| context root child grandchild helper |
	context := self context.
	root := context at: 'session'.
	root prompt: 'Delegate a question'.
	helper := GtLACPSubagentExamples new.
	child := helper
			announce: 'attention-child'
			title: 'Reviewer'
			in: root.
	helper
		task: 'Review the interface'
		from: root
		to: child
		id: 'attention-child-task'.
	grandchild := helper
			announce: 'attention-grandchild'
			title: 'Designer'
			in: child.
	helper
		task: 'Choose a layout'
		from: child
		to: grandchild
		id: 'attention-grandchild-task'.
	GtLACPElicitationExamples new
		receive: (GtLACPElicitationExamples new questionParametersFor: grandchild)
		id: 'nested-attention-question'
		in: grandchild.
	context
		at: 'child' put: child;
		at: 'grandchild' put: grandchild;
		at: 'request' put: grandchild currentTurn elicitationRequests first.
	^ context
]

{ #category : #fixtures }
GtLACPAttentionExamples >> permissionContext [
	| context session |
	context := self context.
	session := context at: 'session'.
	session prompt: 'Inspect the directory'.
	GtLACPPermissionScripterExamples new
		receivePermissionIn: session
		requestId: 'attention-permission'.
	context at: 'request' put: session currentTurn permissionRequests first.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> permissionDecisionsRemoveNotification [
	<gtExample>
	| context |
	#('allow' 'deny')
		do: [ :choice | 
			context := self permissionContext.
			self assert: (context at: 'notifications') size equals: 1.
			(context at: 'request') resolve: choice.
			self assert: (context at: 'notifications') size equals: 0.
			self assert: (context at: 'session') presentationState equals: #prompting ].
	^ context
]

{ #category : #fixtures }
GtLACPAttentionExamples >> questionContext [
	| context session |
	context := self context.
	session := context at: 'session'.
	session prompt: 'Ask about the interface'.
	GtLACPElicitationExamples new
		receive: (GtLACPElicitationExamples new questionParametersFor: session)
		id: 'attention-question'
		in: session.
	context at: 'request' put: session currentTurn elicitationRequests first.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> remoteCancellationRemovesNotification [
	<gtExample>
	| context request |
	context := self questionContext.
	request := context at: 'request'.
	request session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'method' -> '$/cancel_request'.
				'params' -> {'requestId' -> request requestId} asDictionary} asDictionary.
	self assert: request state equals: #cancel.
	self assert: (context at: 'notifications') size equals: 0.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> remotePermissionCancellationRemovesNotification [
	<gtExample>
	| context request |
	context := self permissionContext.
	request := context at: 'request'.
	request session connection transport
		receive: {'jsonrpc' -> '2.0'.
				'method' -> '$/cancel_request'.
				'params' -> {'requestId' -> request requestId} asDictionary} asDictionary.
	self assert: request state equals: #cancelled.
	self assert: (context at: 'notifications') size equals: 0.
	self assert: request session pendingInteractions isEmpty.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> resolvedBeforePublication [
	<gtExample>
	| context notification notifications |
	context := self questionContext.
	notification := GtLACPInputNeededNotification new
			request: (context at: 'request');
			yourself.
	(context at: 'request') decline.
	notifications := GtNotifications new.
	notifications addNotification: notification.
	self assert: notifications size equals: 0.
	^ context
]

{ #category : #examples }
GtLACPAttentionExamples >> skipAndCancelRemoveNotification [
	<gtExample>
	| context |
	#(decline cancel)
		do: [ :action | 
			context := self questionContext.
			(context at: 'request') perform: action.
			self assert: (context at: 'notifications') size equals: 0.
			self assert: (context at: 'session') pendingInteractions isEmpty ].
	^ context
]
