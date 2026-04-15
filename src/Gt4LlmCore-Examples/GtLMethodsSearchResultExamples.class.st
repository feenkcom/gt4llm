"
Examples for GtLMethodsSearchResult.
"
Class {
	#name : #GtLMethodsSearchResultExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultCreation [
	<gtExample>
	| references result |
	references := { GtLMagritteToolForMethodReferences >> #name }.
	result := GtLMethodsSearchResult fromReferences: references.
	self assert: result foundMethods size equals: 1.
	self assert: result foundMethods first methodName equals: #name.
	self assert: result mayHaveMore not.
	^ result
]

{ #category : #examples }
GtLMethodsSearchResultExamples >> methodsSearchResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock referenceJson expected |
	domainObject := self methodsSearchResultCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	referenceJson := NeoJSONObject new
		at: #classSide put: false;
		at: #methodClassName put: 'GtLMagritteToolForMethodReferences';
		at: #methodName put: 'name';
		yourself.
	expected := Dictionary new
		at: #foundMethods put: (NeoJSONArray with: referenceJson);
		at: #mayHaveMore put: false;
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
