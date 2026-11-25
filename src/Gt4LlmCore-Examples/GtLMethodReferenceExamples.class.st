Class {
	#name : #GtLMethodReferenceExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodReferenceExamples >> differentMethodReferences [
	<gtExample>
	| first second |
	first := GtLMethodReference new
		methodClassName: 'Object';
		methodName: 'printString';
		classSide: false;
		yourself.
	second := GtLMethodReference new
		methodClassName: 'Object';
		methodName: 'yourself';
		classSide: false;
		yourself.
	self assert: first ~= second.
	^ first
]

{ #category : #examples }
GtLMethodReferenceExamples >> equalMethodReferences [
	<gtExample>
	| first second |
	first := GtLMethodReference new
		methodClassName: 'Object';
		methodName: 'printString';
		classSide: false;
		yourself.
	second := GtLMethodReference new
		methodClassName: 'Object';
		methodName: 'printString';
		classSide: false;
		yourself.
	self assert: first equals: second.
	self assert: first hash equals: second hash.
	^ first
]

{ #category : #examples }
GtLMethodReferenceExamples >> inheritedClassSideMethodReferenceMissingDomainObject [
	<gtExample>
	<return: #GtLMissingInheritedMethodDomainObject>
	| methodReferenceObject domainObject definingMethod |
	methodReferenceObject := GtLMethodReference new
			methodClassName: #GtLMethodReferenceExamples;
			methodName: #new;
			classSide: true;
			yourself.
	definingMethod := GtLMethodReferenceExamples class lookupSelector: #new.

	self assert: (GtLMethodReferenceExamples class includesSelector: #new) not.
	self assert: methodReferenceObject existsInImage equals: false.

	domainObject := methodReferenceObject
			compiledMethodIfPresent: [ :aMethod | aMethod ]
			ifMissing: [ :anErrorResult | anErrorResult ].
	self assert: (domainObject isKindOf: GtLMissingInheritedMethodDomainObject).
	self
		assert: domainObject missingObjectName
		equals: 'GtLMethodReferenceExamples class>>#new'.
	self
		assert: domainObject definingMethodReference
		equals: (GtLMethodReference fromCompiledMethod: definingMethod).

	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> inheritedMethodReference [
	<gtExample>
	<return: #GtLMethodReference>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference new
			methodClassName: #GtLMethodReferenceExamples;
			methodName: #printString;
			classSide: false;
			yourself.

	self assert: (GtLMethodReferenceExamples includesSelector: #printString) not.
	self assert: methodReferenceObject existsInImage equals: false.

	^ methodReferenceObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> inheritedMethodReferenceLookup [
	<gtExample>
	<return: #CompiledMethod>
	| method |
	method := self inheritedMethodReference
			lookupCompiledMethodIfPresent: [ :aMethod | aMethod ]
			ifMissing: [ :anErrorResult | anErrorResult ].

	self
		assert: method
		equals: (GtLMethodReferenceExamples lookupSelector: #printString).

	^ method
]

{ #category : #examples }
GtLMethodReferenceExamples >> inheritedMethodReferenceMissingDomainObject [
	<gtExample>
	<return: #GtLMissingInheritedMethodDomainObject>
	| domainObject definingReference |
	domainObject := self inheritedMethodReference
			compiledMethodIfPresent: [ :aMethod | aMethod ]
			ifMissing: [ :anErrorResult | anErrorResult ].
	definingReference := GtLMethodReference
			fromCompiledMethod: (GtLMethodReferenceExamples lookupSelector: #printString).

	self assert: (domainObject isKindOf: GtLMissingInheritedMethodDomainObject).
	self assert: domainObject isErrorDomainObject.
	self
		assert: domainObject missingObjectName
		equals: 'GtLMethodReferenceExamples>>#printString'.
	self assert: domainObject definingMethodReference equals: definingReference.
	self
		assert: domainObject errorMessage
		equals: 'GtLMethodReferenceExamples>>#printString is not defined in its own class: it is inherited. Its source is '
				, definingReference methodSignature.

	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> inheritedMethodReferenceMissingDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self inheritedMethodReferenceMissingDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.

	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.

	jsonData := dataBlock compositeJsonData.
	self
		assert: (jsonData at: 'missingObjectName')
		equals: domainObject missingObjectName.
	self assert: (jsonData at: 'errorMessage') equals: domainObject errorMessage.
	self
		assert: ((jsonData at: 'definingMethodReference') at: 'methodClassName')
		equals: domainObject definingMethodReference methodClassName.
	self
		assert: ((jsonData at: 'definingMethodReference') at: 'methodName')
		equals: 'printString'.
	self
		assert: ((jsonData at: 'definingMethodReference') at: 'classSide')
		equals: false.

	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:).

	self
		assert: methodReferenceObject methodName
		equals: 'fromCompiledMethod:'.
	self
		assert: methodReferenceObject methodClassName
		equals: 'GtLMethodReference'.
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

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodClassSideDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self methodReferenceObjectFromCompiledMethodClassSide.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: 'methodName' put: 'fromCompiledMethod:';
		at: 'classSide' put: true;
		at: 'methodClassName' put: 'GtLMethodReference';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodInstanceSide [
	<gtExample>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference fromCompiledMethod: (GtLMethodReferenceExamples>>#methodReferenceObjectFromCompiledMethodInstanceSide).

	self
		assert: methodReferenceObject methodName
		equals: 'methodReferenceObjectFromCompiledMethodInstanceSide'.
	self
		assert: methodReferenceObject methodClassName
		equals: 'GtLMethodReferenceExamples'.
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
	self assert: methodReferenceObject existsInImage.

	^ methodReferenceObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> methodReferenceObjectFromCompiledMethodInstanceSideDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self methodReferenceObjectFromCompiledMethodInstanceSide.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := Dictionary new
		at: 'methodName' put: 'methodReferenceObjectFromCompiledMethodInstanceSide';
		at: 'classSide' put: false;
		at: 'methodClassName' put: 'GtLMethodReferenceExamples';
		yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLMethodReferenceExamples >> missingLocalMethodDomainObjectWithoutDefiningMethod [
	"Without a defining method reference the error message falls back to the general one"

	<gtExample>
	<return: #GtLMissingTraitMethodDomainObject>
	| domainObject |
	domainObject := GtLMissingTraitMethodDomainObject new.
	self assert: domainObject errorMessage equals: ''.
	domainObject objectName: 'Example>>#method'.
	self assert: domainObject errorMessage equals: 'Example>>#method is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> nonClassGlobalMethodReferenceMissingDomainObject [
	"A global that is not a class is reported as a missing class"

	<gtExample>
	<return: #GtLMissingDomainObject>
	| domainObject |
	domainObject := self
			resolveMethod: #printString
			inClassNamed: 'Smalltalk'
			classSide: false.
	self assert: domainObject class equals: GtLMissingDomainObject.
	self assert: domainObject errorMessage equals: 'Smalltalk is not found'.
	^ domainObject
]

{ #category : #examples }
GtLMethodReferenceExamples >> nonExistingMethodReference [
	<gtExample>
	| methodReferenceObject |
	methodReferenceObject := GtLMethodReference new
		methodClassName: #GtLMethodReferenceExamples;
		methodName: #nonExistingSelector;
		classSide: false;
		yourself.

	self
		assert: methodReferenceObject methodSignature
		equals: 'GtLMethodReferenceExamples>>#nonExistingSelector'.
	self assert: methodReferenceObject existsInImage equals: false.

	^ methodReferenceObject
]

{ #category : #private }
GtLMethodReferenceExamples >> resolveMethod: aSelector inClassNamed: aClassName classSide: aBoolean [
	^ (GtLMethodReference new
		methodClassName: aClassName;
		methodName: aSelector;
		classSide: aBoolean;
		yourself)
		compiledMethodIfPresent: [ :aMethod | aMethod ]
		ifMissing: [ :anErrorResult | anErrorResult ]
]
