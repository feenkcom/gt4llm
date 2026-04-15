"
Examples for GtLClassSubclasses.
"
Class {
	#name : #GtLClassSubclassesExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassSubclassesExamples >> classSubclassesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expectedJson |
	domainObject := self classSubclassesDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#givenClassName -> 'SampleClass'.
		#subclassNames -> (NeoJSONArray with: 'A' with: 'B').
		#mayHaveMore -> true
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassSubclassesExamples >> classSubclassesDomainObject [
	<gtExample>
	| result |
	result := GtLClassSubclasses new
		givenClassName: 'SampleClass';
		subclassNames: { 'A'. 'B' };
		mayHaveMore: true;
		yourself.
	self assert: result givenClassName equals: 'SampleClass'.
	self assert: result subclassNames size equals: 2.
	self assert: result mayHaveMore.
	^ result
]
