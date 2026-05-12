Class {
	#name : #GtVectorDbLepiterKey,
	#superclass : #Object,
	#instVars : [
		'lepiterDbName',
		'lepiterPageName',
		'lepiterSnippetUid'
	],
	#category : #'Gt4Llm-VectorDb-Model'
}

{ #category : #'llm-generated' }
GtVectorDbLepiterKey >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	(self class = anObject class) ifFalse: [ ^ false ].
	^ self lepiterDbName = anObject lepiterDbName
		and: [ self lepiterPageName = anObject lepiterPageName
		and: [ self lepiterSnippetUid = anObject lepiterSnippetUid ] ]
]

{ #category : #'llm-generated' }
GtVectorDbLepiterKey >> hash [
	^ {
		self lepiterDbName.
		self lepiterPageName.
		self lepiterSnippetUid } hash
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterDbName [
	^ lepiterDbName
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterDbName: anObject [
	lepiterDbName := anObject
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPage [

	^ (LeDatabasesRegistry defaultLogicalDatabase databaseNamed: self lepiterDbName)
		pageNamed: self lepiterPageName.
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPageName [
	^ lepiterPageName
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterPageName: anObject [
	lepiterPageName := anObject
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterSnippetUid [
	^ lepiterSnippetUid
]

{ #category : #accessing }
GtVectorDbLepiterKey >> lepiterSnippetUid: anObject [
	lepiterSnippetUid := anObject
]
