Class {
	#name : #GtLToolForLepiterKnowledgeBases,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #visiting }
GtLToolForLepiterKnowledgeBases >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForLepiterKnowledgeBases: self
]

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
			GtLLepiterKnowledgeBase new
				databaseName: each databaseName;
				uuidString: each uuidString;
				pageCount: each pageCount;
				storeLocation: each storeLocation asString;
				yourself ])
]
