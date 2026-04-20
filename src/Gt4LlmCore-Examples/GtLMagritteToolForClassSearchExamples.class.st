"
Examples for GtLMagritteToolForClassSearch.
"
Class {
	#name : #GtLMagritteToolForClassSearchExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : 'Gt4LlmCore-Examples-Tools'
}

{ #category : #'examples - data views' }
GtLMagritteToolForClassSearchExamples >> searchClassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| call domainObject compositeView dataBlock jsonData |
	call := self searchClassesWithMatches.
	domainObject := call result targetObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: #foundClassNames) isNotEmpty.
	self assert: (jsonData at: #mayHaveMore) not.
	
	^ dataBlock
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithEmptyQuery [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> ''
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMatches [
	<gtExample>
	| call targetObject queryLower |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> 'GtLToolForClass'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isNotEmpty.
	queryLower := 'GtLToolForClass' asLowercase.
	self assert: (targetObject foundClassNames anySatisfy: [ :each | each asLowercase includesSubstring: queryLower ]).
	self assert: targetObject mayHaveMore not.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMissingQuery [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {} asDictionary.
	
	self
		assertMissingRequiredProperties: call result targetObject
		withPropertyNames: #('query')
		path: #(nil)
		errorMessage: 'required properties missing [query]'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithMoreThan200Matches [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> 'Object'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames size equals: 200.
	self assert: (targetObject foundClassNames allSatisfy: [ :each | each includesSubstring: 'Object' ]).
	self assert: targetObject mayHaveMore.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithNilQuery [
	<gtExample>
	| call |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> nil
		} asDictionary.
	
	self
		assertJSONSchemaValidationError: call result targetObject
		withPath: #('query')
		errorMessage: '@[query] string expected'.
		
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassSearchExamples >> searchClassesWithNoMatches [
	<gtExample>
	| call targetObject |
	
	call := self
		executeTool: GtLMagritteToolForClassSearch new
		withArguments: {
			'query' -> 'ClassNameThatDoesNotExist42'
		} asDictionary.
	targetObject := call result targetObject.
	
	self assert: (targetObject isKindOf: GtLClassesSearchResult).
	self assert: targetObject foundClassNames isEmpty.
	self assert: targetObject mayHaveMore not.
		
	^ call
]
