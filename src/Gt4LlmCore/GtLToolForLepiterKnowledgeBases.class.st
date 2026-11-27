Class {
	#name : #GtLToolForLepiterKnowledgeBases,
	#superclass : #GtLAbstractLepiterTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> description [
	^ 'Lists the Lepiter databases (knowledge bases). databaseId is the id that the other Lepiter tools take.

Example JSON response:
{"knowledgeBases": [{"databaseId": "dklrfmltzaib6womkfkknkfap", "databaseName": "My notes", "pageCount": 42, "storeLocation": "file:///path/to/database"}]}'
]

{ #category : #accessing }
GtLToolForLepiterKnowledgeBases >> name [
	^ 'lepiterKnowledgeBases'
]

{ #category : #execution }
GtLToolForLepiterKnowledgeBases >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	^ GtLLepiterKnowledgeBases new
		knowledgeBases: (self snippetLocator databases
				collect: [ :each | GtLLepiterKnowledgeBase forDatabase: each ])
]
