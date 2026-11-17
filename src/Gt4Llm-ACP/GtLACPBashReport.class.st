"
I present the command, description and recorded output of an ACP Bash tool call. I retain the call rather than a payload snapshot, so my accessors read its current data. My shell coder executes locally only on explicit user action; it does not replace the recorded ACP output.
"
Class {
	#name : #GtLACPBashReport,
	#superclass : #Object,
	#instVars : [
		'toolCall'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPBashReport >> command [
	^ toolCall bashCommand
]

{ #category : #'gt - extensions' }
GtLACPBashReport >> gtCodeAndOutputFor: aView [
	"What command was requested, why, and what output was recorded?
	Opening this view never executes the command. Rerunning the shell coder is local
	and does not replace the recorded ACP output."

	<gtView>
	self command ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Code and output';
		priority: -1;
		stencil: [ | container |
			container := BrVerticalPane new.
			container matchParent
				addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
				background: BrGlamorousColors backdropColor;
				addChild: (self shellCoder asExpandedOnlyElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited;
						hMatchParent);
				addChild: ((self gtOutputFor: GtPhlowEmptyView new) asElement
						margin: (BlInsets all: 10);
						background: Color white;
						addAptitude: BrShadowAptitude;
						vFitContentLimited;
						hMatchParent).
			container ]
]

{ #category : #'gt - extensions' }
GtLACPBashReport >> gtOutputFor: aView [
	"What output was recorded for this command in the ACP payload?"

	^ aView textEditor
		title: 'Recorded output';
		text: [ self outputText ]
]

{ #category : #accessing }
GtLACPBashReport >> outputText [
	"Keep recorded text verbatim rather than JSON-quoting it."

	| output |
	output := toolCall data
			at: 'rawOutput'
			ifAbsent: [ toolCall data at: 'content' ifAbsent: [ nil ] ].
	output ifNil: [ ^ '' ].
	^ output isString
		ifTrue: [ output ]
		ifFalse: [ STONJSON toStringPretty: output ]
]

{ #category : #converting }
GtLACPBashReport >> shellCoder [
	"Use the shell snippet coder with bindings local to this inspector, not the ACP session."

	| source coder |
	source := self source.
	source ifNil: [ ^ nil ].
	coder := LeShellScriptSnippet new newCoder.
	coder pharoBindings: GtSharedVariablesBindings new.
	coder currentSourceString: source.
	^ coder
]

{ #category : #accessing }
GtLACPBashReport >> source [
	| command description |
	command := self command.
	command ifNil: [ ^ nil ].
	description := (toolCall data at: 'rawInput')
			at: 'description'
			ifAbsent: [ '' ].
	^ String
		streamContents: [ :stream | 
			(description isString and: [ description notEmpty ])
				ifTrue: [ description
						linesDo: [ :line | 
							stream
								nextPutAll: '# ';
								nextPutAll: line;
								lf ].
					stream lf ].
			stream nextPutAll: command ]
]

{ #category : #accessing }
GtLACPBashReport >> toolCall [
	^ toolCall
]

{ #category : #accessing }
GtLACPBashReport >> toolCall: aToolCall [
	toolCall := aToolCall
]
