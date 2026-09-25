Class {
	#name : #GtLMcpFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#instVars : [
		'mcpClient',
		'toolDefinition'
	],
	#category : #'Gt4LlmCore-Mcp'
}

{ #category : #accessing }
GtLMcpFunctionTool >> description [
	^ toolDefinition
		at: 'description'
		ifAbsent: [ '' ]
]

{ #category : #accessing }
GtLMcpFunctionTool >> mcpClient [
	^ mcpClient
]

{ #category : #accessing }
GtLMcpFunctionTool >> mcpClient: anObject [
	mcpClient := anObject
]

{ #category : #accessing }
GtLMcpFunctionTool >> name [
	^ toolDefinition at: 'name'
]

{ #category : #accessing }
GtLMcpFunctionTool >> parametersJsonSchemaDictionary [
	^ toolDefinition at: 'inputSchema'
]

{ #category : #execution }
GtLMcpFunctionTool >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments result |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	result := mcpClient
		callToolResult: self name
		withArguments: arguments.

	^ GtLPlainJson forString: result
]

{ #category : #accessing }
GtLMcpFunctionTool >> toolDefinition [
	^ toolDefinition
]

{ #category : #accessing }
GtLMcpFunctionTool >> toolDefinition: anObject [
	toolDefinition := anObject
]
