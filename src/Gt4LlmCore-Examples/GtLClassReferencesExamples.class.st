"
Examples for GtLClassReferences.
"
Class {
	#name : #GtLClassReferencesExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassReferencesExamples >> classReferencesCreation [
	<gtExample>
	| reference result |
	reference := GtLMethodReference fromCompiledMethod: (GtLMagritteToolForClassReferences >> #name).
	result := GtLClassReferences new
		givenClassName: 'GtLMagritteToolForClassReferences';
		references: { reference };
		mayHaveMore: true;
		yourself.
	self assert: result givenClassName equals: 'GtLMagritteToolForClassReferences'.
	self assert: result references size equals: 1.
	self assert: result mayHaveMore.
	^ result
]

{ #category : #examples }
GtLClassReferencesExamples >> classReferencesDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := self classReferencesCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#givenClassName -> 'GtLMagritteToolForClassReferences'.
		#references -> (NeoJSONArray with: (NeoJSONObject new
			at: #methodClassName put: 'GtLMagritteToolForClassReferences';
			at: #methodName put: 'name';
			at: #classSide put: false;
			yourself)).
		#mayHaveMore -> true
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]
