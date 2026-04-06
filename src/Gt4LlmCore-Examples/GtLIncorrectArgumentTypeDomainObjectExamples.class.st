Class {
	#name : #GtLIncorrectArgumentTypeDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLIncorrectArgumentTypeDomainObjectExamples >> emptyIncorrectArgumentTypeDomainObject [
	<gtExample>
	<return: #GtLIncorrectArgumentTypeDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentTypeDomainObject new.
	self assert: domainObject argumentName isNil.
	self assert: domainObject argumentValue isNil.
	self assert: domainObject expectedArgumentValueKind isNil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#argumentName -> nil.
		#argumentValue -> nil.
		#expectedArgumentValueKindName -> nil.
		#errorMessage -> 'nil must be a kind of nil, not a UndefinedObject'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLIncorrectArgumentTypeDomainObjectExamples >> incorrectArgumentTypeDomainObjectWithCustomErrorMessage [
	<gtExample>
	<return: #GtLIncorrectArgumentTypeDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentTypeDomainObject new
		argumentName: 'amount';
		argumentValue: #(1 2 3);
		expectedArgumentValueKind: Number;
		errorMessage: 'Custom error: amount requires a numeric value'.
	self assert: domainObject argumentName equals: 'amount'.
	self assert: domainObject argumentValue equals: #(1 2 3).
	self assert: domainObject expectedArgumentValueKind equals: Number.
	self assert: domainObject errorMessage equals: 'Custom error: amount requires a numeric value'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#argumentName -> 'amount'.
		#argumentValue -> #(1 2 3).
		#expectedArgumentValueKindName -> 'Number'.
		#errorMessage -> 'Custom error: amount requires a numeric value'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLIncorrectArgumentTypeDomainObjectExamples >> incorrectArgumentTypeDomainObjectWithDetails [
	<gtExample>
	<return: #GtLIncorrectArgumentTypeDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentTypeDomainObject new
		argumentName: 'count';
		argumentValue: 'five';
		expectedArgumentValueKind: Integer.
	self assert: domainObject argumentName equals: 'count'.
	self assert: domainObject argumentValue equals: 'five'.
	self assert: domainObject expectedArgumentValueKind equals: Integer.
	self assert: domainObject errorMessage equals: 'count must be a kind of Integer, not a ByteString'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#argumentName -> 'count'.
		#argumentValue -> 'five'.
		#expectedArgumentValueKindName -> 'Integer'.
		#errorMessage -> 'count must be a kind of Integer, not a ByteString'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
