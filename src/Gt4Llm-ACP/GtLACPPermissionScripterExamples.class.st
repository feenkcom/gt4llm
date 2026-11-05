"
I exercise permission toolbars, retained decisions and pending-interaction visibility in root and delegated work areas.
"
Class {
	#name : #GtLACPPermissionScripterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPPermissionScripterExamples >> cancelledPermissionDisplayed [
	<gtExample>
	| scripter |
	scripter := self pendingPermissionDisplayed.
	scripter doStep: [ :step | step block: [ scripter model session cancelTurn ] ].
	scripter pulseUntilReady.
	self assert: scripter model state equals: #cancelled.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-decision-permission-1';
				value: [ :editor | editor text asString ]
					equals: [ 'Permission cancelled' ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPPermissionScripterExamples >> childPermissionOpensWork [
	<gtExample>
	| root child helper scripter permission |
	root := GtLACPExamples new session.
	root prompt: 'Ask a worker to inspect the directory'.
	helper := GtLACPSubagentExamples new.
	child := helper
			announce: 'permission-worker'
			title: 'Directory worker'
			in: root.
	helper
		task: 'Inspect the directory'
		from: root
		to: child
		id: 'permission-task'.
	scripter := BlScripter new
			extent: 1100 @ 900;
			model: root;
			element: root asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				notExists ].
	scripter
		doStep: [ :step | step block: [ self receivePermissionIn: child requestId: 'child-permission' ] ].
	scripter pulseUntilReady.
	permission := child currentTurn permissionRequests first.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isExpanded ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-child-permission';
				exists ].
	scripter click
		id: #'acp-permission-allow';
		play.
	scripter pulseUntilReady.
	self assert: permission state equals: #selected.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-decision-child-permission';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPPermissionScripterExamples >> latePermissionOpensWork [
	<gtExample>
	| session scripter |
	session := GtLACPExamples new session.
	session prompt: 'Read the directory'.
	scripter := BlScripter new
			extent: 1000 @ 700;
			model: session;
			element: session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				notExists ].
	scripter
		doStep: [ :step | step block: [ self receivePermissionIn: session requestId: 'late-permission' ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isExpanded ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-late-permission';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPPermissionScripterExamples >> manualCollapseSurvivesRefresh [
	<gtExample>
	| scripter |
	scripter := self pendingPermissionDisplayed.
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		doStep: [ :step | step block: [ scripter model session announceChanged ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isCollapsed ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				notExists ].
	scripter click
		id: #'acp-work-toggle';
		play.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #building }
GtLACPPermissionScripterExamples >> pendingPermissionDisplayed [
	<gtExample>
	| permission scripter |
	permission := GtLACPExamples new pendingPermission.
	scripter := BlScripter new
			extent: 1000 @ 700;
			model: permission;
			element: permission session asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-section';
				satisfies: #isExpanded ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				satisfies: [ :toolbar | 
					toolbar class = BrToolbar
						and: [ (toolbar items count: [ :item | item isKindOf: BrButton ]) = 2 ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-kind-tool-1';
				satisfies: [ :badge | badge text asString = 'tool' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				satisfies: [ :button | button label asString = permission toolCall shortDescription ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-content';
				satisfies: [ :work | 
					(GtLACPSessionExamples new editorsIn: work)
						noneSatisfy: [ :editor | editor text asString includesSubstring: 'Permission required' ] ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #fixtures }
GtLACPPermissionScripterExamples >> receivePermissionIn: aSession requestId: anId [
	aSession connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> anId.
				'method' -> 'session/request_permission'.
				'params'
					-> {'sessionId' -> aSession remoteSessionId.
							'toolCall'
								-> {'toolCallId' -> 'permission-tool'.
										'title' -> 'Read directory'.
										'status' -> 'pending'} asDictionary.
							'options'
								-> {{'optionId' -> 'allow'.
											'name' -> 'Allow once'.
											'kind' -> 'allow_once'} asDictionary.
										{'optionId' -> 'deny'.
											'name' -> 'Reject once'.
											'kind' -> 'reject_once'} asDictionary}} asDictionary} asDictionary
]

{ #category : #examples }
GtLACPPermissionScripterExamples >> rejectedPermissionDisplayed [
	<gtExample>
	| scripter |
	scripter := self pendingPermissionDisplayed.
	scripter click
		id: #'acp-permission-deny';
		play.
	scripter pulseUntilReady.
	self assert: scripter model decision kind equals: 'reject_once'.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-decision-permission-1';
				value: [ :editor | editor text asString ] equals: [ 'Reject once' ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPPermissionScripterExamples >> selectedPermissionDisplayed [
	<gtExample>
	| scripter permission |
	scripter := self pendingPermissionDisplayed.
	permission := scripter model.
	scripter click
		id: #'acp-permission-allow';
		play.
	scripter pulseUntilReady.
	self assert: permission state equals: #selected.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-toolbar-permission-1';
				notExists ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-decision-permission-1';
				value: [ :editor | editor text asString ] equals: [ 'Allow once' ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ permission toolCall updateFrom: {'status' -> 'running'} asDictionary.
					permission session announceChanged ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-tool-summary-tool-1';
				satisfies: [ :button | button label asString includesSubstring: 'working' ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-permission-decision-permission-1';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
