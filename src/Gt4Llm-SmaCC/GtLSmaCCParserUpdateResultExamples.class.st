Class {
	#name : #GtLSmaCCParserUpdateResultExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCParserUpdateResultExamples >> basicUpdateResult [
	<gtExample>
	| result oldGrammar newGrammar |
	oldGrammar := GtSmaCCGrammar forDefinition: '<token>: \d+; Expr: <token>;'.
	newGrammar := GtSmaCCGrammar forDefinition: '<token>: \d+; Expr: <token> <token>;'.
	result := GtLSmaCCParserUpdateResult new
		parserClass: #TestParser;
		oldGrammar: oldGrammar;
		newGrammar: newGrammar.
	
	self assert: result parserClass equals: #TestParser.
	self assert: result oldGrammar equals: oldGrammar.
	self assert: result newGrammar equals: newGrammar.
	self assert: result isErrorDomainObject not.
	^ result
]

{ #category : #examples }
GtLSmaCCParserUpdateResultExamples >> updateResultDataViewSerialization [
	<gtExample>
	| result compositeView dataBlock jsonData |
	result := self basicUpdateResult.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: #parserClass) equals: #TestParser.
	"oldGrammar and newGrammar are not serialized via Magritte"
	
	^ dataBlock
]
