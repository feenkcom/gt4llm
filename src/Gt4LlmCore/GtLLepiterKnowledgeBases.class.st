Class {
	#name : #GtLLepiterKnowledgeBases,
	#superclass : #Object,
	#instVars : [
		'knowledgeBases'
	],
	#category : 'Gt4LlmCore-Magritte Objects'
}

{ #category : #'gt-views' }
GtLLepiterKnowledgeBases >> gtKnowledgeBasesFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Knowledge bases';
		priority: 1;
		items: [ self knowledgeBases ];
		column: 'Name' text: [ :each | each databaseName ifNil: [ 'Unnamed' ] ];
		column: 'Pages' text: [ :each | each pageCount ];
		column: 'UUID' text: #uuidString
]

{ #category : #accessing }
GtLLepiterKnowledgeBases >> knowledgeBases [
	^ knowledgeBases
]

{ #category : #accessing }
GtLLepiterKnowledgeBases >> knowledgeBases: aCollection [
	knowledgeBases := aCollection
]

{ #category : #magritte }
GtLLepiterKnowledgeBases >> knowledgeBasesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Knowledge bases';
		accessor: #knowledgeBases;
		classes: {GtLLepiterKnowledgeBase};
		beRequired
]

{ #category : #'llm views' }
GtLLepiterKnowledgeBases >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView magritteObject: [ self ]
]
