"
I provide a client with an in-memory transport for stored-session loading and inspector action examples.
"
Class {
	#name : #GtLACPFixtureStoredSession,
	#superclass : #GtLACPStoredSession,
	#instVars : [
		'client'
	],
	#category : #'Gt4Llm-ACP-Examples'
}

{ #category : #accessing }
GtLACPFixtureStoredSession >> client: aClient [
	client := aClient
]

{ #category : #loading }
GtLACPFixtureStoredSession >> newClient [
	^ client
]
