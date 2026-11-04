"
I exercise work-graph lanes, chronological delegation and return edges, live completion, and lazy vertical scrolling with in-image ACP fixtures.
"
Class {
	#name : #GtLACPWorkGraphExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPWorkGraphExamples >> connectionsFlowDownward [
	<gtExample>
	| scripter graph |
	scripter := self nestedWorkDisplayed.
	graph := scripter model.
	(graph rows select: [ :row | row sourceLane ~~ row targetLane ])
		do: [ :row | 
			scripter
				assertStep: [ :step | 
					step
						id: ('acp-work-graph-row-' , row index asString) asSymbol;
						satisfies: [ :element | 
							| line |
							line := element childNamed: #'acp-work-graph-connection'.
							line class = BlManhattanLineElement
								and: [ line fromPosition x = row sourceLane x
										and: [ line toPosition x = row targetLane x
												and: [ line fromPosition y < line toPosition y
														and: [ line toDirection y > 0
																and: [ line geometry cornerRadius > 0
																		and: [ line hasToHead not and: [ line hasFromHead not ] ] ] ] ] ] ] ] ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> emptyConversation [
	<gtExample>
	| graph scripter |
	graph := GtLACPExamples new session asWorkGraph.
	self assert: graph rows isEmpty.
	scripter := BlScripter new
			extent: 1100 @ 600;
			model: graph;
			element: graph asElement;
			yourself.
	scripter pulseUntilReady.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> largeWork [
	<gtExample>
	| root examples |
	root := GtLACPExamples new session.
	root prompt: 'Inspect many files'.
	examples := GtLACPSubagentExamples new.
	1
		to: 500
		do: [ :index | 
			examples
				update: {'sessionUpdate' -> 'tool_call'.
						'toolCallId' -> ('graph-file-' , index asString).
						'title' -> ('Inspect file ' , index asString).
						'status' -> 'completed'} asDictionary
				for: root ].
	^ root asWorkGraph
]

{ #category : #examples }
GtLACPWorkGraphExamples >> lazyScrolling [
	<gtExample>
	| graph scripter |
	graph := self largeWork.
	self assert: graph rows size equals: 501.
	scripter := BlScripter new
			extent: 1200 @ 500;
			model: graph;
			element: graph asElement;
			yourself.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				satisfies: [ :element | 
					| count |
					count := 0.
					element
						withAllChildrenBreadthFirstDo: [ :each | (each isKindOf: GtLACPWorkGraphRowElement) ifTrue: [ count := count + 1 ] ].
					count > 0 and: [ count < 50 ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-501';
				notExists ].
	scripter
		doStep: [ :step | step block: [ :element | element listElement scrollToItem: graph rows last ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-501';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> liveCompletion [
	<gtExample>
	| root turn examples child graph scripter firstRow childLane |
	examples := GtLACPSubagentExamples new.
	root := GtLACPExamples new session.
	turn := root prompt: 'Delegate a lookup'.
	child := examples
			announce: 'graph-live-worker'
			title: 'Live worker'
			in: root.
	examples
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'graph-live-call'.
				'title' -> 'Find the class'.
				'status' -> 'in_progress'} asDictionary
		for: child.
	graph := root asWorkGraph.
	childLane := graph laneFor: child.
	firstRow := graph rows first.
	scripter := BlScripter new
			extent: 1300 @ 700;
			model: graph;
			element: graph asElement;
			yourself.
	scripter pulseUntilReady.
	self assert: graph rows size equals: 3.
	scripter
		doStep: [ :step | 
			step
				label: 'Finish the worker and add its return edge';
				block: [ examples
						update: {'sessionUpdate' -> 'tool_call_update'.
								'toolCallId' -> 'graph-live-call'.
								'status' -> 'completed'} asDictionary
						for: child.
					examples reply: 'The class is ready.' in: child.
					examples idle: child ] ].
	scripter pulseUntilReady.
	self assert: graph rows size equals: 4.
	self assert: graph rows last kind equals: #reply.
	self assert: graph rows last targetLane equals: (graph laneFor: root).
	self assert: (graph laneFor: child) == childLane.
	self assert: graph rows first == firstRow.
	scripter
		doStep: [ :step | 
			step
				label: 'Return the final root reply to its caller';
				block: [ examples reply: 'The lookup is complete.' in: root.
					root connection transport
						receive: {'jsonrpc' -> '2.0'.
								'id' -> turn request id.
								'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary ] ].
	scripter pulseUntilReady.
	self assert: graph rows size equals: 5.
	self assert: graph rows last targetLane equals: graph callerLane.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-5';
				satisfies: [ :element | element row kind = #reply ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> nestedLanesAndReturns [
	<gtExample>
	| graph child nested sibling starts replies tools |
	graph := self nestedWork.
	self assert: graph lanes size equals: 5.
	self assert: graph rows size equals: 12.
	child := graph session childSessions first.
	sibling := graph session childSessions second.
	nested := child childSessions first.
	starts := graph rows select: [ :row | row kind = #spawn ].
	self assert: starts size equals: 3.
	self
		assert: (starts detect: [ :row | row turn session == nested ]) sourceLane
		equals: (graph laneFor: child).
	self
		assert: (starts detect: [ :row | row turn session == sibling ]) sourceLane
		equals: (graph laneFor: graph session).
	replies := graph rows select: [ :row | row kind = #reply ].
	self assert: replies size equals: 4.
	self
		assert: (replies detect: [ :row | row turn session == nested ]) targetLane
		equals: (graph laneFor: child).
	self
		assert: (replies detect: [ :row | row turn session == graph session ]) targetLane
		equals: graph callerLane.
	tools := graph rows select: [ :row | row kind = #tool ].
	self assert: tools size equals: 4.
	self
		assert: ((1 to: graph rows size - 1)
				allSatisfy: [ :i | (graph rows at: i) timestamp <= (graph rows at: i + 1) timestamp ]).
	^ graph
]

{ #category : #examples }
GtLACPWorkGraphExamples >> nestedWork [
	<gtExample>
	| root turn examples child nested sibling |
	examples := GtLACPSubagentExamples new.
	root := GtLACPExamples new session.
	turn := root prompt: 'Implement and review a change'.
	examples
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'graph-main'.
				'title' -> 'Read project'.
				'status' -> 'completed'} asDictionary
		for: root.
	child := examples
			announce: 'graph-implementation'
			title: 'Implementation'
			in: root.
	examples
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'graph-build'.
				'title' -> 'Build the change'.
				'status' -> 'completed'} asDictionary
		for: child.
	nested := examples
			announce: 'graph-tests'
			title: 'Tests'
			in: child.
	examples
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'graph-test'.
				'title' -> 'Run tests'.
				'status' -> 'completed'} asDictionary
		for: nested.
	sibling := examples
			announce: 'graph-review'
			title: 'Review'
			in: root.
	examples
		update: {'sessionUpdate' -> 'tool_call'.
				'toolCallId' -> 'graph-review-call'.
				'title' -> 'Review the patch'.
				'status' -> 'completed'} asDictionary
		for: sibling.
	examples reply: 'Tests passed.' in: nested.
	examples idle: nested.
	examples reply: 'Review complete.' in: sibling.
	examples idle: sibling.
	examples reply: 'Implementation complete.' in: child.
	examples idle: child.
	examples reply: 'The change is complete and reviewed.' in: root.
	root connection transport
		receive: {'jsonrpc' -> '2.0'.
				'id' -> turn request id.
				'result' -> {'stopReason' -> 'end_turn'} asDictionary} asDictionary.
	^ root asWorkGraph
]

{ #category : #examples }
GtLACPWorkGraphExamples >> nestedWorkDisplayed [
	<gtExample>
	| graph scripter |
	graph := self nestedLanesAndReturns.
	scripter := BlScripter new
			extent: 1300 @ 700;
			model: graph;
			element: graph asElement;
			yourself.
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-list';
				satisfies: [ :list | list items size = 12 ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-4';
				satisfies: [ :element | 
					element row kind = #tool
						and: [ element parent class = GtLACPWorkGraphListRowElement
								and: [ element parent row == element row
										and: [ element parent children first == element
												and: [ (element childNamed: #'acp-work-graph-marker') geometry class
														= BlCircleGeometry ] ] ] ] ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> reasoningDoesNotRebuildGraph [
	<gtExample>
	| graph scripter root examples firstGraphElement |
	root := GtLACPExamples new session.
	root prompt: 'Explain the project'.
	graph := root asWorkGraph.
	examples := GtLACPSubagentExamples new.
	scripter := BlScripter new
			extent: 1100 @ 600;
			model: graph;
			element: graph asElement;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-1';
				satisfies: [ :element | 
					firstGraphElement := element.
					true ] ].
	scripter
		doStep: [ :step | 
			step
				block: [ examples
						update: {'sessionUpdate' -> 'agent_thought_chunk'.
								'content'
									-> {'type' -> 'text'.
											'text' -> 'I am inspecting the project.'} asDictionary} asDictionary
						for: root ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-row-1';
				satisfies: [ :element | element == firstGraphElement ] ].
	self assert: graph rows size equals: 1.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> reusedAgentKeepsItsLane [
	<gtExample>
	| root child graph firstLane secondTurn |
	child := GtLACPSubagentExamples new reusedChildConversation.
	root := child rootSession.
	graph := root asWorkGraph.
	firstLane := graph laneFor: child.
	secondTurn := child turns last.
	self assert: child turns size equals: 2.
	self
		assert: ((graph rows
				select: [ :row | row kind = #spawn and: [ row turn session == child ] ])
				allSatisfy: [ :row | row lane == firstLane and: [ row sourceLane == (graph laneFor: root) ] ]).
	self
		assert: (graph rows detect: [ :row | row kind = #spawn and: [ row turn == secondTurn ] ])
				sourceLane
		equals: (graph laneFor: root).
	graph refresh.
	self assert: (graph laneFor: child) == firstLane.
	^ graph
]

{ #category : #examples }
GtLACPWorkGraphExamples >> selectingRowSelectsItsObject [
	<gtExample>
	| scripter graph selected spawned |
	scripter := self nestedWorkDisplayed.
	graph := scripter model.
	selected := OrderedCollection new.
	spawned := OrderedCollection new.
	scripter element
		when: GtPhlowObjectToSelect
		do: [ :event | 
			selected add: event object.
			event consumed: true ].
	scripter element
		when: GtPhlowObjectToSpawn
		do: [ :event | 
			spawned add: event object.
			event consumed: true ].
	scripter click
		id: #'acp-work-graph-event-4';
		play.
	self assert: selected last == (graph rows at: 4) object.
	self assert: spawned isEmpty.
	scripter click
		id: #'acp-work-graph-event-5';
		play.
	self assert: selected last == (graph rows at: 5) object.
	self assert: spawned isEmpty.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPWorkGraphExamples >> stoppedTurnWithoutReply [
	<gtExample>
	| root turn graph |
	root := GtLACPExamples new session.
	turn := root prompt: 'A request that fails'.
	turn fail: 'Fixture failure'.
	graph := root asWorkGraph.
	self assert: graph rows size equals: 2.
	self assert: graph rows last kind equals: #stop.
	self assert: graph rows last description equals: 'Fixture failure'.
	self assert: graph rows last lane lastRow equals: 2.
	^ graph
]

{ #category : #examples }
GtLACPWorkGraphExamples >> workGraphInSessionTool [
	<gtExample>
	| root element scripter |
	root := self nestedWork session.
	element := (GtLACPSessionTool forChat: root) asElementDo: [ :widget | widget ].
	scripter := BlScripter new
			extent: 1400 @ 800;
			model: root;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-list';
				notExists ].
	scripter
		clickStep: [ :step | 
			step
				onChildFromBlock: [ :tool | 
					(tool viewsContainerElement children first childNamed: #tabbar) children
						detect: [ :tab | tab label asString = 'Work graph' ] ] ].
	scripter
		assertStep: [ :step | 
			step
				id: #'acp-work-graph-list';
				satisfies: [ :list | list items size = 12 ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]
