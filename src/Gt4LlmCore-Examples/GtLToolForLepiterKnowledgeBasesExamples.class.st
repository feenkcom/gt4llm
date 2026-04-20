Class {
	#name : #GtLToolForLepiterKnowledgeBasesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterKnowledgeBasesExamples >> knowledgeBasesLookup [
	<gtExample>
	| call targetObject |
	call := self
		executeTool: GtLToolForLepiterKnowledgeBases new
		withArguments: Dictionary new.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterKnowledgeBases).
	self assert: targetObject knowledgeBases isNotEmpty.
	self assert: (targetObject knowledgeBases allSatisfy: [ :each | each uuidString isNotEmpty ]).
	self assert: (targetObject knowledgeBases allSatisfy: [ :each | each pageCount isNumber ]).
	^ call
]
