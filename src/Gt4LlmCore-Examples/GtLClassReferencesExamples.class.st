"
Examples for GtLClassReferences.
"
Class {
	#name : #GtLClassReferencesExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
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
	| domainObject compositeView dataBlock expectedJson |
	
	domainObject := self classReferencesCreation.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#givenClassName -> 'GtLMagritteToolForClassReferences'.
		#references -> (NeoJSONArray with: (NeoJSONObject new
			at: #methodClassName put: 'GtLMagritteToolForClassReferences';
			at: #methodName put: 'name';
			at: #classSide put: false;
			yourself)).
		#mayHaveMore -> true
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]
