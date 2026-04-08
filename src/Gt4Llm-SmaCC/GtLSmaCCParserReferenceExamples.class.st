Class {
	#name : #GtLSmaCCParserReferenceExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCParserReferenceExamples >> basicParserReference [
	<gtExample>
	| reference |
	reference := GtLSmaCCParserReference new
		parserClass: 'MyParser'.
	
	self assert: reference parserClass equals: 'MyParser'.
	self assert: reference isErrorDomainObject not.
	^ reference
]

{ #category : #examples }
GtLSmaCCParserReferenceExamples >> parserReferenceDataViewSerialization [
	<gtExample>
	| reference compositeView dataBlock jsonData |
	reference := self basicParserReference.
	compositeView := reference llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assert: jsonData equals: {
		#parserClass -> 'MyParser'
	} asDictionary.
	
	^ dataBlock
]
