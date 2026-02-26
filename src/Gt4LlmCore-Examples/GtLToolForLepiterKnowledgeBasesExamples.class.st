Class {
	#name : #GtLToolForLepiterKnowledgeBasesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForLepiterKnowledgeBasesExamples >> knowledgeBasesLookup [
	<gtExample>
	| tool call result model |
	tool := GtLToolForLepiterKnowledgeBases new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GtLMagritteInputModel).
	model := result model.
	self assert: model knowledgeBases isNotEmpty.
	self assert: (model knowledgeBases allSatisfy: [ :each | each uuidString isNotEmpty ]).
	self assert: (model knowledgeBases allSatisfy: [ :each | each pageCount isNumber ]).
	^ call
]
