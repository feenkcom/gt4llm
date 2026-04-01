Class {
	#name : #GtLSmaCCParserCreationResultExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCParserCreationResultExamples >> basicCreationResult [
	<gtExample>
	| result grammar |
	grammar := GtSmaCCGrammar forDefinition: '<token>: \d+; Expr: <token>;'.
	result := GtLSmaCCParserCreationResult new
		parserClass: #TestParser;
		createGrammar: grammar.
	
	self assert: result parserClass equals: #TestParser.
	self assert: result createGrammar equals: grammar.
	self assert: result isErrorDomainObject not.
	^ result
]

{ #category : #examples }
GtLSmaCCParserCreationResultExamples >> creationResultDataViewSerialization [
	<gtExample>
	| result compositeView dataBlock jsonData |
	result := self basicCreationResult.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #parserClass) equals: #TestParser.
	"createGrammar is not included in Magritte description, only parserClass"
	
	^ dataBlock
]
