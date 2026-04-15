"
Examples for GtLRefactoringDomainObject subclasses.
"
Class {
	#name : #GtLRefactoringDomainObjectExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #'examples - class domain object' }
GtLRefactoringDomainObjectExamples >> basicClassDomainObject [
	<gtExample>
	| namespace domainObject targetClass |
	namespace := self exampleNamespace.
	targetClass := namespace classNamed: 'GtLExampleDomainBase'.
	
	domainObject := GtLRefactoringClassDomainObject new
		model: namespace;
		targetClass: targetClass.
	
	self assert: domainObject model equals: namespace.
	self assert: domainObject targetClass equals: targetClass.
	
	^ domainObject
]

{ #category : #'examples - class references domain object' }
GtLRefactoringDomainObjectExamples >> basicClassReferencesDomainObject [
	<gtExample>
	| namespace domainObject targetClass references |
	namespace := self exampleNamespace.
	targetClass := namespace classNamed: 'GtLExampleDomainBase'.
	references := Array streamContents: [ :stream |
		namespace allReferencesToClass: targetClass do: [ :each | stream << each ] ].
	
	domainObject := GtLRefactoringClassReferencesDomainObject new
		model: namespace;
		targetClass: targetClass;
		references: references.
	
	self assert: domainObject targetClass equals: targetClass.
	self assert: domainObject references size >= 1.
	
	^ domainObject
]

{ #category : #'examples - class search domain object' }
GtLRefactoringDomainObjectExamples >> basicClassSearchDomainObject [
	<gtExample>
	| domainObject |
	domainObject := GtLRefactoringClassSearchDomainObject new
		model: self exampleNamespace;
		query: 'Domain';
		allClassNames: #('GtLExampleDomainBase' 'GtLExampleDomainChild');
		foundClassNames: #('GtLExampleDomainBase' 'GtLExampleDomainChild').
	
	self assert: domainObject query equals: 'Domain'.
	self assert: domainObject foundClassNames size equals: 2.
	
	^ domainObject
]

{ #category : #'examples - class subclasses domain object' }
GtLRefactoringDomainObjectExamples >> basicClassSubclassesDomainObject [
	<gtExample>
	| namespace domainObject targetClass subclasses |
	namespace := self exampleNamespace.
	targetClass := namespace classNamed: 'GtLExampleDomainBase'.
	subclasses := targetClass subclasses asArray.
	
	domainObject := GtLRefactoringClassSubclassesDomainObject new
		model: namespace;
		targetClass: targetClass;
		subclasses: subclasses.
	
	self assert: domainObject targetClass equals: targetClass.
	self assert: domainObject subclasses size equals: 1.
	
	^ domainObject
]

{ #category : #'examples - method implementors domain object' }
GtLRefactoringDomainObjectExamples >> basicMethodImplementorsDomainObject [
	<gtExample>
	| namespace domainObject implementors |
	namespace := self exampleNamespace.
	implementors := Array streamContents: [ :stream |
		namespace allImplementorsOf: #value do: [ :each | stream nextPut: each ] ].
	
	domainObject := GtLRefactoringMethodImplementorsDomainObject new
		model: namespace;
		methodName: 'value';
		implementors: implementors.
	
	self assert: domainObject methodName equals: 'value'.
	self assert: domainObject implementors size >= 2.
	
	^ domainObject
]

{ #category : #'examples - method references domain object' }
GtLRefactoringDomainObjectExamples >> basicMethodReferencesDomainObject [
	<gtExample>
	| namespace domainObject references |
	namespace := self exampleNamespace.
	references := Array streamContents: [ :stream |
		namespace allReferencesTo: #value do: [ :each | stream << each ] ].
	
	domainObject := GtLRefactoringMethodReferencesDomainObject new
		model: namespace;
		methodName: 'value';
		references: references;
		mayHaveMore: false.
	
	self assert: domainObject methodName equals: 'value'.
	self assert: domainObject mayHaveMore not.
	
	^ domainObject
]

{ #category : #'examples - method source code domain object' }
GtLRefactoringDomainObjectExamples >> basicMethodSourceCodeDomainObject [
	<gtExample>
	| namespace domainObject targetClass method |
	namespace := self exampleNamespace.
	targetClass := namespace classNamed: 'GtLExampleDomainBase'.
	method := targetClass methodFor: #value.
	
	domainObject := GtLRefactoringMethodSourceCodeDomainObject new
		model: namespace;
		method: method.
	
	self assert: domainObject methodName equals: 'value'.
	self assert: domainObject methodClassName equals: 'GtLExampleDomainBase'.
	
	^ domainObject
]

{ #category : #'examples - class domain object' }
GtLRefactoringDomainObjectExamples >> classDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self basicClassDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'class') equals: 'GtLExampleDomainBase'.
	self assert: (jsonData at: 'superclass') equals: 'Object'.
	self assert: ((jsonData at: 'instanceSlots') includes: 'value').
	
	^ dataBlock
]

{ #category : #'examples - class references domain object' }
GtLRefactoringDomainObjectExamples >> classReferencesDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self basicClassReferencesDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'class') equals: 'GtLExampleDomainBase'.
	self assert: (jsonData at: 'references') isCollection.
	
	^ dataBlock
]

{ #category : #'examples - class search domain object' }
GtLRefactoringDomainObjectExamples >> classSearchDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicClassSearchDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	expected := Dictionary new
		at: 'query' put: 'Domain';
		at: 'foundClasses' put: #('GtLExampleDomainBase' 'GtLExampleDomainChild');
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - class subclasses domain object' }
GtLRefactoringDomainObjectExamples >> classSubclassesDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData expected |
	domainObject := self basicClassSubclassesDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	expected := Dictionary new
		at: 'class' put: 'GtLExampleDomainBase';
		at: 'subclasses' put: #('GtLExampleDomainChild');
		yourself.
	self assert: jsonData equals: expected.
	
	^ dataBlock
]

{ #category : #'examples - namespace' }
GtLRefactoringDomainObjectExamples >> exampleNamespace [
	"Create a namespace with example classes and methods for testing"
	<gtExample>
	| namespace baseClass childClass |
	namespace := GtRBNamespace new.
	namespace defineClass: 'Object subclass: #GtLExampleDomainBase
		instanceVariableNames: ''value''
		classVariableNames: ''''
		package: ''Gt4LlmCore-Examples-Fixtures'''.
	namespace defineClass: 'GtLExampleDomainBase subclass: #GtLExampleDomainChild
		instanceVariableNames: ''''
		classVariableNames: ''''
		package: ''Gt4LlmCore-Examples-Fixtures'''.
	baseClass := namespace classNamed: 'GtLExampleDomainBase'.
	childClass := namespace classNamed: 'GtLExampleDomainChild'.
	baseClass compile: 'value
	^ value' classified: 'accessing'.
	baseClass compile: 'value: anObject
	value := anObject' classified: 'accessing'.
	childClass compile: 'value
	^ super value + 1' classified: 'accessing'.
	childClass compile: 'callsBase
	^ GtLExampleDomainBase new' classified: 'examples'.
	^ namespace
]

{ #category : #'examples - method implementors domain object' }
GtLRefactoringDomainObjectExamples >> methodImplementorsDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self basicMethodImplementorsDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'methodName') equals: 'value'.
	self assert: (jsonData at: 'implementors') isCollection.
	
	^ dataBlock
]

{ #category : #'examples - method references domain object' }
GtLRefactoringDomainObjectExamples >> methodReferencesDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self basicMethodReferencesDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.
	self assert: (jsonData at: 'methodName') equals: 'value'.
	self assert: (jsonData at: 'mayHaveMoreReferences') equals: false.
	self assert: (jsonData at: 'references') isCollection.
	self assert: ((jsonData at: 'references') includes: 'GtLExampleDomainChild>>#value').
	
	^ dataBlock
]

{ #category : #'examples - method source code domain object' }
GtLRefactoringDomainObjectExamples >> methodSourceCodeDomainObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData |
	domainObject := self basicMethodSourceCodeDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock llmJsonData.

	self assert: (jsonData at: 'methodName') equals:  'value'.
	self assert: (jsonData at: 'className') equals:  'GtLExampleDomainBase'.
	self 
		assert: (jsonData at: 'sourceCode') withInternalLineEndings 
		equals: ('value
	^ value' ) withInternalLineEndings.
	
	^ dataBlock
]
