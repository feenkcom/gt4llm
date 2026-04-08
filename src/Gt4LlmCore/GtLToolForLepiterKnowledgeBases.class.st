Class {
	#name : #GtLToolForLepiterKnowledgeBases,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> description [
	^ 'Retrieve the registered Lepiter knowledge bases.'
]

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> name [
	^ 'lepiterKnowledgeBases'
]

{ #category : #execution }
GtLToolForLepiterKnowledgeBases >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| databases |
	databases := LeDatabasesRegistry defaultLogicalDatabase databases.
	^ GtLLepiterKnowledgeBases new
		knowledgeBases: (databases collect: [ :each |
			GtLLepiterKnowledgeBase forDatabase: each ])
]
