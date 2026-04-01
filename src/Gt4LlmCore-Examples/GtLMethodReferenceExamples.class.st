Class {
	#name : #GtLMethodReferenceExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:).

	self
		assert: methodReferenceObject methodName
		equals: #fromCompiledMethod:.
	self
		assert: methodReferenceObject methodClassName
		equals: #GtLMethodReference.
	self
		assert: methodReferenceObject classSide
		equals: true.
	self
		assert: methodReferenceObject isClassSide
		equals: true.
	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMethodReference class>>#fromCompiledMethod:'.
	self
		assert: methodReferenceObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodReferenceObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).

	^ methodReferenceObject
]

{ #category : #'examples - data view' }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodClassSideDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self methodReferenceObjectFromCompiledMethodClassSide.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #methodName put: #fromCompiledMethod:;
		at: #classSide put: true;
		at: #methodClassName put: #GtLMethodReference;
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodInstanceSide [
	<gtExample>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference fromCompiledMethod: (GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).

	self
		assert: methodReferenceObject methodName
		equals: #methodReferenceObjectFromCompiledMethodInstanceSide.
	self
		assert: methodReferenceObject methodClassName
		equals: #GtLMethodReferenceExamples.
	self
		assert: methodReferenceObject classSide
		equals: false.
	self
		assert: methodReferenceObject isClassSide
		equals: false.
	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide'.
	self
		assert: methodReferenceObject methodClass
		equals: GtLMethodReferenceExamples.
	self
		assert: methodReferenceObject compiledMethod
		equals: (GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).

	^ methodReferenceObject
]

{ #category : #'examples - data view' }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodInstanceSideDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self methodReferenceObjectFromCompiledMethodInstanceSide.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expected := Dictionary new
		at: #methodName put: #methodReferenceObjectFromCompiledMethodInstanceSide;
		at: #classSide put: false;
		at: #methodClassName put: #GtLMethodReferenceExamples;
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]
