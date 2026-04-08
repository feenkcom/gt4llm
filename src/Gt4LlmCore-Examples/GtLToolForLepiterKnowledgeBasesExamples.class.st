Class {
	#name : #GtLToolForLepiterKnowledgeBasesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterKnowledgeBasesExamples >> knowledgeBasesLookup [
	<gtExample>
	| targetObject |
	
	targetObject := self
		executeTool: GtLToolForLepiterKnowledgeBases new
		withArguments: Dictionary new.
	
	self assert: (targetObject isKindOf: GtLLepiterKnowledgeBases).
	self assert: targetObject knowledgeBases isNotEmpty.
	self assert: (targetObject knowledgeBases allSatisfy: [ :each | each uuidString isNotEmpty ]).
	self assert: (targetObject knowledgeBases allSatisfy: [ :each | each pageCount isNumber ]).
	
	^ targetObject
]
