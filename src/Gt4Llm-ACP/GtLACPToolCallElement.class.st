"
I present a tool call, including its work badge, summary and permission controls, or its elicitation questions. I retain the tool call model and own its presentation. The assistant message element coordinates when I am rebuilt.
"
Class {
	#name : #GtLACPToolCallElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'toolCall'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #building }
GtLACPToolCallElement >> build [
	self removeChildren.
	self id: ('acp-tool-' , toolCall id asString) asSymbol.
	toolCall elicitationRequests
		ifEmpty: [ self buildToolContent ]
		ifNotEmpty: [ self buildQuestions ]
]

{ #category : #building }
GtLACPToolCallElement >> buildQuestions [
	self margin: BlInsets empty.
	toolCall elicitationRequests
		do: [ :question | 
			self
				addChild: (question asElement
						padding: BlInsets empty;
						margin: (BlInsets
								top: 2
								left: 5
								bottom: 2
								right: 5);
						yourself) ]
]

{ #category : #building }
GtLACPToolCallElement >> buildToolContent [
	| line kind summary |
	kind := GtLACPWorkBadgeElement new
			id: ('acp-tool-kind-' , toolCall id asString) asSymbol;
			text: 'tool';
			yourself.
	summary := BrButton new
			id: ('acp-tool-summary-' , toolCall id asString) asSymbol;
			aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
			hMatchParent;
			alignCenterLeft;
			padding: BlInsets empty;
			label: toolCall summary;
			action: [ :button | button phlow spawnObject: toolCall ];
			yourself.
	line := BrHorizontalPane new
			id: ('acp-tool-line-' , toolCall id asString) asSymbol;
			hMatchParent;
			vFitContent;
			addChild: kind;
			addChild: summary;
			yourself.
	toolCall permissionRequests
		ifNotEmpty: [ line
				addChild: (GtLACPInputNeededElement new
						id: ('acp-tool-input-needed-' , toolCall id asString) asSymbol;
						margin: (BlInsets right: 6);
						constraintsDo: [ :constraints | constraints linear vertical alignCenter ];
						forTool: toolCall;
						yourself)
				at: 2 ].
	line
		when: BlClickEvent
		do: [ :event | 
			event consumed: true.
			line phlow spawnObject: toolCall ].

	self
		margin: (BlInsets
				top: 2
				left: 5
				bottom: 2
				right: 5).
	self addChild: line.
	toolCall permissionRequests
		do: [ :permission | self addChild: permission asElement ]
]

{ #category : #initialization }
GtLACPToolCallElement >> initialize [
	super initialize.
	self
		hMatchParent;
		vFitContent
]

{ #category : #accessing }
GtLACPToolCallElement >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLACPToolCallElement >> toolCall: aToolCall [
	toolCall := aToolCall.
	self build
]
