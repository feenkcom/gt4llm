"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPClaudeCodeClient,
	#superclass : #GtLACPClient,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPClaudeCodeClient >> defaultConfiguration [
 ^ GtLACPClaudeCodeClientConfiguration new
]

{ #category : #accessing }
GtLACPClaudeCodeClient >> displayName [
 ^ 'Claude Code'
]
