Class {
	#name : #GtLLepiterPage,
	#superclass : #Object,
	#instVars : [
		'targetPage'
	],
	#category : 'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLLepiterPage class >> forPage: aPage [
	^ self new 
		targetPage: aPage 
]

{ #category : #views }
GtLLepiterPage >> gtLepiterPageViewFor: aView [
	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Page';
		priority: 1;
		object: [ self targetPage ];
		view: #gtLiveFor:
]

{ #category : #'llm views' }
GtLLepiterPage >> llmRawDataViewFor: aDataView [
	<gtLlmDataView>
	
	^ aDataView 
		title: 'Page Contents';
		jsonData: [ 
			| serializedString |
			serializedString := LeJsonV4 uniqueInstance serializePretty: self targetPage.
			NeoJSONReader fromString: serializedString ]
]

{ #category : #printing }
GtLLepiterPage >> printOn: aStream [
	self targetPage printOn: aStream
]

{ #category : #accessing }
GtLLepiterPage >> targetPage [
	^ targetPage
]

{ #category : #accessing }
GtLLepiterPage >> targetPage: aLePage [
	targetPage := aLePage
]
