Class {
	#name : #GtLSmaCCDefinitionExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCDefinitionExamples >> basicDefinition [
	<gtExample>
	| definition |
	definition := GtLSmaCCDefinition new
		parserClass: 'TestParser';
		scannerClass: 'TestScanner';
		package: 'TestPackage';
		definition: '<token>: \d+; Expr: <token>;'.
	
	self assert: definition parserClass equals: 'TestParser'.
	self assert: definition scannerClass equals: 'TestScanner'.
	self assert: definition package equals: 'TestPackage'.
	self assert: definition definition equals: '<token>: \d+; Expr: <token>;'.
	self assert: definition isErrorDomainObject not.
	^ definition
]

{ #category : #examples }
GtLSmaCCDefinitionExamples >> definitionDataViewSerialization [
	<gtExample>
	| definition compositeView dataBlock jsonData |
	definition := self basicDefinition.
	compositeView := definition llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: jsonData equals: {
		#parserClass -> 'TestParser'.
		#scannerClass -> 'TestScanner'.
		#package -> 'TestPackage'.
		#definition -> '<token>: \d+; Expr: <token>;'
	} asDictionary.
	
	^ dataBlock
]
