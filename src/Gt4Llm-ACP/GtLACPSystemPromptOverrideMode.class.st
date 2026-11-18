"
I replace the agent's default instructions when the agent advertises override support.
"
Class {
	#name : #GtLACPSystemPromptOverrideMode,
	#superclass : #GtLACPSystemPromptMode,
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #validating }
GtLACPSystemPromptOverrideMode >> validateCapabilities: capabilities [
	super validateCapabilities: capabilities.
	capabilities supportsSystemPromptOverride
		ifFalse: [ self error: 'Agent does not support overriding the system prompt' ]
]

{ #category : #accessing }
GtLACPSystemPromptOverrideMode >> wireName [
	^ 'override'
]
