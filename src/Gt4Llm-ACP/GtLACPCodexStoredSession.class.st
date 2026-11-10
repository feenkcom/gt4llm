"
I describe a Codex conversation discovered on disk and create its matching ACP client when loaded.
"
Class {
	#name : #GtLACPCodexStoredSession,
	#superclass : #GtLACPStoredSession,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #loading }
GtLACPCodexStoredSession >> newClient [
	^ GtLACPCodexClient new
]
