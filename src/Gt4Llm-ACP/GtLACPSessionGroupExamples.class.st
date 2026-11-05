"
I exercise session groups and their direct and forwarded conversation-tree views, including empty groups and live connection updates.
"
Class {
	#name : #GtLACPSessionGroupExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPSessionGroupExamples >> connectionConversationTreeDisplayed [
	<gtExample>
	| root element scripter |
	root := GtLACPExamples new session.
	element := (root connection gtConversationTreeFor: GtPhlowView empty)
			asElementDo: [ :widget | 
				widget
					background: Color white;
					yourself ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: root connection;
			element: element;
			yourself.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Codex';
				exists ].
	scripter
		doStep: [ :step | 
			step
				block: [ GtLACPSubagentExamples new
						announce: 'group-live-child'
						title: 'Group worker'
						in: root ] ].
	scripter pulseUntilReady.
	scripter
		assertStep: [ :step | 
			step
				onPhlowCellWithString: 'Group worker';
				exists ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionGroupExamples >> conversationTreeDisplayed [
	<gtExample>
	| group element scripter |
	group := self nestedSessions.
	element := (group gtConversationTreeFor: GtPhlowView empty)
			asElementDo: [ :widget | 
				widget
					background: Color white;
					yourself ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: group;
			element: element;
			yourself.
	#('Codex' 'Code reviewer' 'Test investigator' 'API researcher')
		do: [ :title | 
			scripter
				assertStep: [ :step | 
					step
						onPhlowCellWithString: title;
						exists ] ].
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionGroupExamples >> emptyConversationTree [
	<gtExample>
	| group element scripter |
	group := GtLACPSessionGroup new.
	self assert: group isEmpty.
	element := (group gtConversationTreeFor: GtPhlowView empty)
			asElementDo: [ :widget | 
				widget
					background: Color white;
					yourself ].
	scripter := BlScripter new
			extent: 1100 @ 700;
			model: group;
			element: element;
			yourself.
	scripter pulseUntilReady.
	GtLACPSessionExamples new assertNoRenderingErrorsIn: scripter.
	^ scripter
]

{ #category : #examples }
GtLACPSessionGroupExamples >> nestedSessions [
	<gtExample>
	| root collection group |
	root := GtLACPSubagentExamples new nestedConversations.
	collection := {root}.
	group := GtLACPSessionGroup withAll: collection.
	self assert: group items == collection.
	self assert: group size equals: 1.
	self assert: group first == root.
	^ group
]
