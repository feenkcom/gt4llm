Class {
	#name : #GtLClassMethodsDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsDomainObjectDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self classMethodsDomainObjectWithViewMethods.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'className') equals: 'GtABAddressBook'.
	self assert: (jsonData at: 'methods') isNotEmpty.
	self assert: ((jsonData at: 'methods') anySatisfy: [ :m | m includesSubstring: 'gtViewContactsListOn:' ]).
	
	^ dataBlock
]

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsDomainObjectWithHardcodedMethods [
	<gtExample>
	<return: #GtLClassMethodsDomainObject>
	| domainObject method1 method2 |
	method1 := GtLClassMethodsDomainObjectExamples >> #classMethodsDomainObjectWithHardcodedMethods.
	method2 := GtLClassMethodsDomainObjectExamples >> #classMethodsEmptyDataViewSerialization.
	
	domainObject := GtLClassMethodsDomainObject new
		targetClass: GtLClassMethodsDomainObjectExamples;
		methods: { method1. method2 }.
	
	self assert: domainObject targetClass equals: GtLClassMethodsDomainObjectExamples.
	self assert: domainObject methods size equals: 2.
	
	^ domainObject
]

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsDomainObjectWithNoMethods [
	<gtExample>
	<return: #GtLClassMethodsDomainObject>
	| domainObject |
	domainObject := GtLClassMethodsDomainObject new
		targetClass: GtLClassMethodsDomainObjectExamples;
		methods: #().
	
	self assert: domainObject targetClass equals: GtLClassMethodsDomainObjectExamples.
	self assert: domainObject methods isEmpty.
	
	^ domainObject
]

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsDomainObjectWithViewMethods [
	<gtExample>
	<return: #GtLClassMethodsDomainObject>
	| domainObject |
	domainObject := GtLClassMethodsDomainObject new
		targetClass: GtABAddressBook;
		methods: ((Pragma allNamed: #gtView from: GtABAddressBook to: Object) 
			collect: [ :each | each method ]).
	
	self assert: domainObject targetClass equals: GtABAddressBook.
	self assert: domainObject methods isNotEmpty.
	self assert: (domainObject methods anySatisfy: [ :m | m selector = #gtViewContactsListOn: ]).
	
	^ domainObject
]

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsEmptyDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self classMethodsDomainObjectWithNoMethods.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := {
		'className' -> 'GtLClassMethodsDomainObjectExamples'.
		'methods' -> #()
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]

{ #category : #examples }
GtLClassMethodsDomainObjectExamples >> classMethodsHardcodedDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expected |
	domainObject := self classMethodsDomainObjectWithHardcodedMethods.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expected := {
		'className' -> 'GtLClassMethodsDomainObjectExamples'.
		'methods' -> #(
			'GtLClassMethodsDomainObjectExamples>>#classMethodsDomainObjectWithHardcodedMethods'
			'GtLClassMethodsDomainObjectExamples>>#classMethodsEmptyDataViewSerialization'
		)
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	
	^ dataBlock
]
