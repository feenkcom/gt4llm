Class {
	#name : #GtLToolForChatMethodSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchHandlesError [
	<gtExample>
	| tool call result providerWithStubData |
	providerWithStubData := self providerWithStubDataForQuery: '1/0'.
	tool := GtLToolForChatMethodSearch new provider: providerWithStubData.
	call := GtLFunctionToolCall new
			function: {'name' -> tool name.
					'arguments'
						-> {'searchPrompt' -> 'methods that trigger failures'} asDictionary}
					asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Error'.
	^ tool
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> methodSearchReturnsMatches [
	<gtExample>
	| tool call result providerWithStubData |
	providerWithStubData := self
			providerWithStubDataForQuery: 'GtLToolForChatMethodSearch gtReferences'.
	tool := GtLToolForChatMethodSearch new provider: providerWithStubData.
	call := GtLFunctionToolCall new
			function: {'name' -> tool name.
					'arguments'
						-> {'searchPrompt' -> 'methods referencing BlElement'} asDictionary}
					asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: (result includesSubstring: 'GtLToolForChatMethodSearchExamples').
	^ tool
]

{ #category : #examples }
GtLToolForChatMethodSearchExamples >> providerWithStubDataForQuery: string [
	| textJsonString exporter obj |
	obj := GtLPharoScript new content: string.
	exporter := GtMagritteJSONDataExporter forObject: obj.
	textJsonString := '{ "PharoScript": ' , exporter exportObjectAsJsonString , '}'.
	^ GtLOpenAIProviderWithChatMethodSearchStub new
		responseData: {'content' -> {{'text' -> textJsonString} asDictionary}} asDictionary
]
