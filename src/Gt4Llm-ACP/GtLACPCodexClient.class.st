"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPCodexClient,
	#superclass : #GtLACPClient,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPCodexClient >> defaultConfiguration [
 ^ GtLACPCodexClientConfiguration new
]

{ #category : #accessing }
GtLACPCodexClient >> displayName [
 ^ 'Codex'
]
