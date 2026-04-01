Class {
	#name : #GtLLepiterPageDomainObject,
	#superclass : #Object,
	#instVars : [
		'foundPage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #accessing }
GtLLepiterPageDomainObject >> foundPage [
	^ foundPage
]

{ #category : #accessing }
GtLLepiterPageDomainObject >> foundPage: aLePage [
	foundPage := aLePage
]

{ #category : #views }
GtLLepiterPageDomainObject >> gtLepiterPageViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ self foundPage ];
		view: #gtLiveFor:
]

{ #category : #'llm views' }
GtLLepiterPageDomainObject >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView 
		title: 'Page Contents';
		jsonData: [ 
			| serializedString |
			serializedString := LeJsonV4 uniqueInstance serializePretty: self foundPage.
			NeoJSONReader fromString: serializedString ]
]
