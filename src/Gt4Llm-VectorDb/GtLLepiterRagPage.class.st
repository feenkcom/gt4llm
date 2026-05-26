Class {
	#name : #GtLLepiterRagPage,
	#superclass : #Object,
	#instVars : [
		'pageKey',
		'embeddingDistances'
	],
	#category : #'Gt4Llm-VectorDb-Support'
}

{ #category : #accessing }
GtLLepiterRagPage >> embeddingDistances [
	^ embeddingDistances
]

{ #category : #accessing }
GtLLepiterRagPage >> embeddingDistances: anObject [
	embeddingDistances := anObject
]

{ #category : #ui }
GtLLepiterRagPage >> gtLepiterPageFor: aView [
	<gtView>
	
	pageKey ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Page';
		priority: 20;
		object: [ pageKey ];
		view: #gtLepiterPageFor:
]

{ #category : #ui }
GtLLepiterRagPage >> gtSummaryFor: aView [
	<gtView>

	^ aView columnedList
		  title: 'Summary';
		  priority: 10;
		  items: [ self summaryAttributes ];
		  column: #Attribute text: [ :item | item first ];
		  column: #Value text: [ :item | item second ];
		  send: #last.
]

{ #category : #accessing }
GtLLepiterRagPage >> page [

	^ pageKey lepiterPage
]

{ #category : #accessing }
GtLLepiterRagPage >> pageKey [
	^ pageKey
]

{ #category : #accessing }
GtLLepiterRagPage >> pageKey: anObject [
	pageKey := anObject
]

{ #category : #accessing }
GtLLepiterRagPage >> pageName [

	^ pageKey ifNotNil: #lepiterPageName
]

{ #category : #'as yet unclassified' }
GtLLepiterRagPage >> printOn: aStream [

	super printOn: aStream.
	self pageName ifNotNil: [ :pageName |
		aStream parenthesize: 
			[ aStream << pageName ] ]
]

{ #category : #ui }
GtLLepiterRagPage >> summaryAttributes [
	| attributes |

	attributes := pageKey
		ifNil: [ #() ]
		ifNotNil: [ pageKey summaryAttributes ].
	embeddingDistances ifNotNil:
		[ attributes := attributes,
			{
				{ 'Minimum distance'. embeddingDistances first. }.
				{ 'Embedding distances'. embeddingDistances. }.
			} ].
	^ attributes.
]
