Class {
	#name : #GtChromaDbDatabases,
	#superclass : #GtLGroup,
	#instVars : [
		'tenant'
	],
	#category : #'Gt4Llm-ChromaDb-Model'
}

{ #category : #accessing }
GtChromaDbDatabases >> tenant [
	^ tenant
]

{ #category : #accessing }
GtChromaDbDatabases >> tenant: anObject [
	tenant := anObject
]
