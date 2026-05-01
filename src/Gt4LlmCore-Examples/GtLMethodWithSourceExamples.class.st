Class {
	#name : #GtLMethodWithSourceExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodWithSourceExamples >> methodWithSourceDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self methodWithSourceObjectFromCompiledMethodClassSide.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: ((jsonData at: #methodReference) at: #methodName) equals: 'fromCompiledMethod:'.
	self assert: ((jsonData at: #methodReference) at: #methodClassName) equals: 'GtLMethodReference'.
	self assert: ((jsonData at: #methodReference) at: #classSide) equals: true.
	self assert: (jsonData at: #sourceCode) equals: (GtLMethodReference class >> #fromCompiledMethod:) sourceCode.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodWithSourceExamples >> methodWithSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject |
	methodObject := GtLMethodWithSource
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
		equals: (GtLMethodReference class>>#fromCompiledMethod:) sourceCode.

	^ methodObject
]

{ #category : #examples }
GtLMethodWithSourceExamples >> methodWithSourceObjectFromCompiledMethodClassSideJsonExport [
	<gtExample>
	| methodObject jsonObject |
	methodObject := self methodWithSourceObjectFromCompiledMethodClassSide.
	jsonObject := GtMagritteJSONDataExporter exportObject: methodObject.
	self
		assert: jsonObject
		equals: ((NeoJSONObject new)
			at: 'methodReference' put: ((NeoJSONObject new)
				at: 'methodName' put: 'fromCompiledMethod:';
				at: 'methodClassName' put: 'GtLMethodReference';
				at: 'classSide' put: true;
				yourself);
			at: 'sourceCode' put: (GtLMethodReference class>>#fromCompiledMethod:) sourceCode;
			yourself).

	^ jsonObject
]
