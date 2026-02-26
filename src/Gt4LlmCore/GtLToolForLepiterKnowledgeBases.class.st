Class {
	#name : #GtLToolForLepiterKnowledgeBases,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #visiting }
GtLToolForLepiterKnowledgeBases >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForLepiterKnowledgeBases: self
]

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> description [
	^ 'Retrieve the registered Lepiter knowledge bases.'
]

{ #category : #magritte }
GtLToolForLepiterKnowledgeBases >> dummy [
	^ nil
]

{ #category : #magritte }
GtLToolForLepiterKnowledgeBases >> dummyDescription [
	<magritteDescription>
	^ MAStringDescription new
		accessor: #dummy;
		beOptional
]

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> name [
	^ 'lepiterKnowledgeBases'
]

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> parametersDescription [
	^ GtLResponseMagritteFormat new
		name: 'Parameters';
		modelClass: self class
]

{ #category : #execution }
GtLToolForLepiterKnowledgeBases >> privatePerformToolCall: aToolCall [
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
