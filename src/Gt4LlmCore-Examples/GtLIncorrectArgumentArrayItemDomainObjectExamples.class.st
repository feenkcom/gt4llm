Class {
	#name : #GtLIncorrectArgumentArrayItemDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLIncorrectArgumentArrayItemDomainObjectExamples >> emptyIncorrectArgumentArrayItemDomainObject [
	<gtExample>
	<return: #GtLIncorrectArgumentArrayItemDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentArrayItemDomainObject new.
	self assert: domainObject argumentName isNil.
	self assert: domainObject argumentValue isNil.
	self assert: domainObject incorrectItems isNil.
	self assert: domainObject expectedItemKind isNil.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	^ domainObject
]

{ #category : #examples }
GtLIncorrectArgumentArrayItemDomainObjectExamples >> incorrectArgumentArrayItemDomainObjectWithDetails [
	<gtExample>
	<return: #GtLIncorrectArgumentArrayItemDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentArrayItemDomainObject new
		argumentName: 'items';
		argumentValue: #('one' 2 'three');
		incorrectItems: #(2);
		expectedItemKind: String.
	self assert: domainObject argumentName equals: 'items'.
	self assert: domainObject argumentValue equals: #('one' 2 'three').
	self assert: domainObject incorrectItems equals: #(2).
	self assert: domainObject expectedItemKind equals: String.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#argumentName -> 'items'.
		#argumentValue -> #('one' 2 'three').
		#incorrectItems -> #(2).
		#expectedItemKindName -> 'String'.
		#messageText -> 'items must be an array with items of String kind, not a SmallInteger'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]

{ #category : #examples }
GtLIncorrectArgumentArrayItemDomainObjectExamples >> incorrectArgumentArrayItemDomainObjectWithMultipleIncorrectItems [
	<gtExample>
	<return: #GtLIncorrectArgumentArrayItemDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLIncorrectArgumentArrayItemDomainObject new
		argumentName: 'numbers';
		argumentValue: #(1 'two' 3 'four');
		incorrectItems: #('two' 'four');
		expectedItemKind: Integer.
	self assert: domainObject argumentName equals: 'numbers'.
	self assert: domainObject argumentValue equals: #(1 'two' 3 'four').
	self assert: domainObject incorrectItems equals: #('two' 'four').
	self assert: domainObject expectedItemKind equals: Integer.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#argumentName -> 'numbers'.
		#argumentValue -> #(1 'two' 3 'four').
		#incorrectItems -> #('two' 'four').
		#expectedItemKindName -> 'Integer'.
		#messageText -> 'numbers must be an array with items of Integer kind, not a ByteString'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
