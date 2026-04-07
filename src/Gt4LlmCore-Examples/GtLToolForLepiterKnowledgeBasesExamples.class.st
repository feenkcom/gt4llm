Class {
	#name : #GtLToolForLepiterKnowledgeBasesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterKnowledgeBasesExamples >> knowledgeBasesLookup [
	<gtExample>
	| tool call result domainObject |
	tool := GtLToolForLepiterKnowledgeBases new.
	call := GtLFunctionToolCall new.
	call rawArguments: Dictionary new.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	domainObject := result targetObject.
	self assert: (domainObject isKindOf: GtLLepiterKnowledgeBases).
	self assert: domainObject knowledgeBases isNotEmpty.
	self assert: (domainObject knowledgeBases allSatisfy: [ :each | each uuidString isNotEmpty ]).
	self assert: (domainObject knowledgeBases allSatisfy: [ :each | each pageCount isNumber ]).
	^ domainObject
]
