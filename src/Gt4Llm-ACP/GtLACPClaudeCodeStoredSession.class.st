"
I describe a Claude Code conversation discovered on disk and create its matching ACP client when loaded.
"
Class {
	#name : #GtLACPClaudeCodeStoredSession,
	#superclass : #GtLACPStoredSession,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #loading }
GtLACPClaudeCodeStoredSession >> newClient [
	^ GtLACPClaudeCodeClient new
]
