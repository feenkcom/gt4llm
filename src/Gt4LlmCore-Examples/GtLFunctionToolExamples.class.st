"
Examples for GtLFunctionTool.
"
Class {
	#name : #GtLFunctionToolExamples,
	#superclass : #GtLAbstractPlainSchemaFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - tools' }
GtLFunctionToolExamples >> additionTool [
	"Create a simple function tool that adds two numbers"
	<gtExample>
	| tool |
	tool := GtLFunctionTool new
		name: 'add';
		description: 'Adds two numbers';
		parametersDescription: {
			'a' -> 'First number'.
			'b' -> 'Second number'
		} asDictionary;
		block: [ :call | 
			(call arguments at: 'a') + (call arguments at: 'b') ].
	
	self assert: tool name equals: 'add'.
	self assert: tool description equals: 'Adds two numbers'.
	self assert: tool isUsingDataViews.
	
	^ tool
]

{ #category : #examples }
GtLFunctionToolExamples >> additionToolCall [
	"Execute a function tool call and verify result"
	<gtExample>
	| tool call result |
	tool := self additionTool.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'a' -> 3.
		'b' -> 5
	} asDictionary.
	
	result := tool performToolCall: call.
	
	self assert: call tool == tool.
	self assert: result isErrorDomainObject not.
	self assert: result targetObject object equals: 8.
	
	^ call
]

{ #category : #examples }
GtLFunctionToolExamples >> additionToolDataViewSerialization [
	"Verify the data view serialization of function tool result"
	<gtExample>
	| tool call result compositeView dataBlock jsonData objectValue |
	tool := self additionTool.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'a' -> 10.
		'b' -> 20
	} asDictionary.
	
	result := tool performToolCall: call.
	self assert: result isErrorDomainObject not.
	
	compositeView := result targetObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews isNotEmpty.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	objectValue := jsonData at: #objectValue.
	self assert: (objectValue at: 'objectClassName') equals: 'SmallInteger'.
	self assert: (objectValue at: 'objectPrintString') equals: '30'.
	
	^ dataBlock
]

{ #category : #'examples - tools' }
GtLFunctionToolExamples >> stringConcatenationTool [
	"Create a function tool that concatenates strings"
	<gtExample>
	| tool |
	tool := GtLFunctionTool new
		name: 'concat';
		description: 'Concatenates two strings';
		parametersDescription: {
			'first' -> 'First string'.
			'second' -> 'Second string'
		} asDictionary;
		block: [ :call | 
			(call arguments at: 'first'), (call arguments at: 'second') ].
	
	self assert: tool name equals: 'concat'.
	
	^ tool
]

{ #category : #examples }
GtLFunctionToolExamples >> stringConcatenationToolCall [
	"Execute string concatenation tool"
	<gtExample>
	| tool call result |
	tool := self stringConcatenationTool.
	call := GtLFunctionToolCall new.
	call rawArguments: {
		'first' -> 'Hello, '.
		'second' -> 'World!'
	} asDictionary.
	
	result := tool performToolCall: call.
	
	self assert: result isErrorDomainObject not.
	self assert: result targetObject object equals: 'Hello, World!'.
	
	^ call
]
