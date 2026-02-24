Class {
	#name : #GtLToolForChatMethodSearchExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
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
	self assert: result isErrorDomainObject.
	^ call
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
	self assert: result isErrorDomainObject not.
	self
		assert: (result methods
				anySatisfy: [ :each | each methodClass name = 'GtLToolForChatMethodSearchExamples' ]).
	^ call
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
