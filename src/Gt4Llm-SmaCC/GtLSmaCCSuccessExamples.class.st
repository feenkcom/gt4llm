Class {
	#name : #GtLSmaCCSuccessExamples,
	#superclass : #Object,
	#category : 'Gt4Llm-SmaCC-Examples'
}

{ #category : #examples }
GtLSmaCCSuccessExamples >> basicSuccess [
	<gtExample>
	| success |
	success := GtLSmaCCSuccess new
		message: 'The sample was successfully parsed'.
	
	self assert: success message equals: 'The sample was successfully parsed'.
	self assert: success isErrorDomainObject not.
	^ success
]

{ #category : #examples }
GtLSmaCCSuccessExamples >> successDataViewSerialization [
	<gtExample>
	| success compositeView dataBlock jsonData |
	success := self basicSuccess.
	compositeView := success llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	
	jsonData := dataBlock compositeJsonData.
	self assert: jsonData equals: {
		#message -> 'The sample was successfully parsed'
	} asDictionary.
	
	^ dataBlock
]
