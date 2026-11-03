"
I launch the community Python Claude Code ACP bridge with uvx in an isolated tool environment. The package version is explicit and configurable.
"
Class {
	#name : #GtLACPClaudeCodePythonAdapter,
	#superclass : #GtLACPAdapter,
	#instVars : [
		'packageSpecification'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPClaudeCodePythonAdapter >> arguments [
	packageSpecification isEmptyOrNil
		ifTrue: [ self error: 'A Python adapter package is required' ].
	^ {'--from'.
		packageSpecification.
		'--with'.
		'agent-client-protocol==0.7.0'.
		'claude-code-acp'}
]

{ #category : #accessing }
GtLACPClaudeCodePythonAdapter >> displayName [
	^ 'Claude Code (Python)'
]

{ #category : #accessing }
GtLACPClaudeCodePythonAdapter >> executable [
	^ 'uvx'
]

{ #category : #initialization }
GtLACPClaudeCodePythonAdapter >> initialize [
	super initialize.
	packageSpecification := 'claude-code-acp==0.5.1'
]

{ #category : #accessing }
GtLACPClaudeCodePythonAdapter >> packageSpecification [
	^ packageSpecification
]

{ #category : #accessing }
GtLACPClaudeCodePythonAdapter >> packageSpecification: aString [
	packageSpecification := aString
]
