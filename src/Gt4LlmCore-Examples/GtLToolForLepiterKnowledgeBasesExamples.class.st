Class {
	#name : #GtLToolForLepiterKnowledgeBasesExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForLepiterKnowledgeBasesExamples >> knowledgeBasesLookup [
	"Each database is listed with its databaseId, the base 36 id that the other Lepiter tools take"

	<gtExample>
	| call targetObject |
	call := self
			executeTool: GtLToolForLepiterKnowledgeBases new
			withArguments: Dictionary new.
	targetObject := call result targetObject.
	self assert: (targetObject isKindOf: GtLLepiterKnowledgeBases).
	self assert: targetObject knowledgeBases isNotEmpty.
	self
		assert: (targetObject knowledgeBases collect: [ :each | each databaseId ]) asArray
		equals: (LeDatabasesRegistry defaultLogicalDatabase databases
				collect: [ :each | each uuidString ]) asArray.
	self
		assert: (targetObject knowledgeBases allSatisfy: [ :each | each pageCount isNumber ]).
	self
		assert: (((self jsonOf: call) at: 'knowledgeBases')
				allSatisfy: [ :each | (each includesKey: 'databaseId') and: [ (each includesKey: 'uuidString') not ] ]).
	^ call
]
