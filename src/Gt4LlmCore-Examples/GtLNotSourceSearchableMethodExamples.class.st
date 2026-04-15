Class {
	#name : #GtLNotSourceSearchableMethodExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLNotSourceSearchableMethodExamples >> methodWithNotSearchableSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject |
	methodObject := GtLNotSourceSearchableMethod
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:).

	self
		assert: methodObject methodName
		equals: #fromCompiledMethod:.
	self
		assert: methodObject methodClassName
		equals: #GtLMethodReference.
	self
		assert: methodObject isClassSide
		equals: true.
	self
		assert: methodObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).
	self
		assert: methodObject sourceCode
		equals: '<not searchable method>'.

	^ methodObject
]

{ #category : #examples }
GtLNotSourceSearchableMethodExamples >> methodWithNotSearchableSourceObjectFromCompiledMethodClassSideDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected methodRefJson |
	domainObject := self methodWithNotSearchableSourceObjectFromCompiledMethodClassSide.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	methodRefJson := NeoJSONObject new
		at: #methodName put: 'fromCompiledMethod:';
		at: #methodClassName put: 'GtLMethodReference';
		at: #classSide put: true;
		yourself.
	expected := Dictionary new
		at: #methodReference put: methodRefJson;
		at: #sourceCode put: '<not searchable method>';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
