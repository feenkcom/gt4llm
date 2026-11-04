"
Examples that preview ACP class renames in an RBNamespace without changing live classes.
"
Class {
	#name : #GtLACPRenameExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #examples }
GtLACPRenameExamples >> sessionToolRenameApplied [
	<gtExample>
	| model toolSource exampleSource |
	model := RBNamespace new.
	#('GtLACPChatTool' 'GtLACPChatToolElement' 'GtLACPChatExamples')
		do: [ :each | self assert: (Smalltalk globals includesKey: each asSymbol) not ].
	{GtLACPSessionTool.
		GtLACPSessionToolElement.
		GtLACPSessionExamples}
		do: [ :each | self assert: (model classFor: each) notNil ].
	toolSource := ((model classFor: GtLACPSessionTool) methodFor: #asElementDo:)
			source.
	self assert: (toolSource includesSubstring: 'GtLACPSessionToolElement').
	self assert: (toolSource includesSubstring: 'GtLACPChatToolElement') not.
	exampleSource := ((model classFor: GtLACPSessionExamples)
			methodFor: #sessionInspectorTool) source.
	self assert: (exampleSource includesSubstring: 'GtLACPSessionTool forChat:').
	self assert: (exampleSource includesSubstring: 'GtLACPSessionToolElement').
	self assert: (exampleSource includesSubstring: 'GtLACPChatTool') not.
	^ model
]
