Class {
	#name : #GtLCouldNotCreateClassDomainObjectExamples,
	#superclass : #GtLErroneousConditionDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLCouldNotCreateClassDomainObjectExamples >> basicCouldNotCreateClassDomainObject [
	<gtExample>
	<return: #GtLCouldNotCreateClassDomainObject>
	| domainObject |
	domainObject := GtLCouldNotCreateClassDomainObject new
		targetClassName: 'MyNewClass';
		superclass: Object;
		packageName: 'MyPackage';
		packageTagName: 'Core';
		instanceVariableNames: 'slot1 slot2';
		classVariableNames: 'SharedVar';
		exception: (Error new messageText: 'Superclass not found');
		yourself.
	self assert: domainObject targetClassName equals: 'MyNewClass'.
	self assert: domainObject superclassName equals: #Object.
	self assert: domainObject packageName equals: 'MyPackage'.
	self assert: domainObject packageTagName equals: 'Core'.
	self assert: domainObject instanceVariableNames equals: 'slot1 slot2'.
	self assert: domainObject classVariableNames equals: 'SharedVar'.
	self assert: domainObject messageText equals: 'Class creation error: Superclass not found'.
	self assert: domainObject isErrorDomainObject.
	^ domainObject
]

{ #category : #examples }
GtLCouldNotCreateClassDomainObjectExamples >> couldNotCreateClassDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| domainObject compositeView dataBlock expectedJson |
	
	domainObject := self basicCouldNotCreateClassDomainObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	expectedJson := {
		#targetClassName -> 'MyNewClass'.
		#superclassName -> #Object.
		#packageName -> 'MyPackage'.
		#packageTagName -> 'Core'.
		#instanceVariableNames -> 'slot1 slot2'.
		#classVariableNames -> 'SharedVar'.
		#messageText -> 'Class creation error: Superclass not found'
	} asDictionary.
	self assertDataBlock: dataBlock hasLlmJsonData: expectedJson.
	
	^ dataBlock
]

{ #category : #examples }
GtLCouldNotCreateClassDomainObjectExamples >> emptyCouldNotCreateClassDomainObject [
	<gtExample>
	<return: #GtLCouldNotCreateClassDomainObject>
	| domainObject compositeView dataBlock jsonData expectedJson |
	
	domainObject := GtLCouldNotCreateClassDomainObject new.
	self assert: domainObject targetClassName isNil.
	self assert: domainObject superclass isNil.
	self assert: domainObject exception isNil.
	self assert: domainObject messageText equals: 'Class creation error: unknown error'.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#targetClassName -> nil.
		#superclassName -> nil.
		#packageName -> nil.
		#packageTagName -> nil.
		#instanceVariableNames -> nil.
		#classVariableNames -> nil.
		#messageText -> 'Class creation error: unknown error'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ domainObject
]
