"
Abstract superclass for examples testing GtLAbstractMagritteFunctionTool and its subclasses.
"
Class {
	#name : #GtLAbstractMagritteFunctionToolExamples,
	#superclass : #GtLAbstractFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #helpers }
GtLAbstractMagritteFunctionToolExamples >> executeTool: aTool withArguments: aDictionary [
	"Execute the tool with the given arguments and return the tool call.
	Asserts common properties that should be the same for all tool calls."
	
	| call result |
	call := GtLFunctionToolCall new.
	call rawArguments: aDictionary.
	result := aTool performToolCall: call.
	
	self assert: call tool == aTool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: aDictionary size.
	
	^ call
]

{ #category : #helpers }
GtLAbstractMagritteFunctionToolExamples >> executeTool: aTool withArguments: aDictionary inContext: aContext [
	"Execute the tool with the given arguments in the given context and return the tool call.
	Asserts common properties that should be the same for all tool calls."
	
	| call result |
	call := GtLFunctionToolCall new.
	call rawArguments: aDictionary.
	result := aTool performToolCall: call inContext: aContext.
	
	self assert: call tool == aTool.
	self assert: (result isKindOf: GTLDataViewWrapperModel).
	self assert: call arguments size equals: aDictionary size.
	
	^ call
]
