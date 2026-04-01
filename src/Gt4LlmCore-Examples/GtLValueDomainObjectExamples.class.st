Class {
	#name : #GtLValueDomainObjectExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLValueDomainObjectExamples >> basicValueDomainObjectWithInteger [
	<gtExample>
	| domainObject |
	domainObject := GtLValueDomainObject new value: 42.
	
	self assert: domainObject value equals: 42.
	self assert: domainObject isErrorDomainObject not.
	^ domainObject
]

{ #category : #examples }
GtLValueDomainObjectExamples >> basicValueDomainObjectWithString [
	<gtExample>
	| domainObject |
	domainObject := GtLValueDomainObject new value: 'Hello World'.
	
	self assert: domainObject value equals: 'Hello World'.
	self assert: domainObject isErrorDomainObject not.
	^ domainObject
]

{ #category : #examples }
GtLValueDomainObjectExamples >> basicValueDomainObjectWithTestObject [
	<gtExample>
	| domainObject testObject |
	testObject := GtLSerializedObjectValueTestObject exampleInstance.
	domainObject := GtLValueDomainObject new value: testObject.
	
	self assert: domainObject value equals: testObject.
	self assert: domainObject value name equals: 'TestObject'.
	self assert: domainObject value count equals: 42.
	self assert: domainObject value items equals: #('apple' 'banana' 'cherry').
	self assert: domainObject isErrorDomainObject not.
	^ domainObject
]

{ #category : #examples }
GtLValueDomainObjectExamples >> integerDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData valueSlot |
	domainObject := self basicValueDomainObjectWithInteger.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'class') equals: 'GtLValueDomainObject'.
	self assert: (jsonData at: 'superclass') equals: #GtLDomainObject.
	self assert: (jsonData at: 'package') equals: #Gt4LlmCore.
	self assert: ((jsonData at: 'printString') includesSubstring: 'GtLValueDomainObject').
	self assert: (jsonData at: 'allInstanceSlots') size equals: 1.
	
	valueSlot := (jsonData at: 'allInstanceSlots') first.
	self assert: (valueSlot at: 'name') equals: #value.
	self assert: (valueSlot at: 'class') equals: 'SmallInteger'.
	self assert: (valueSlot at: 'value') equals: '42'.
	
	^ dataBlock
]

{ #category : #examples }
GtLValueDomainObjectExamples >> stringDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData valueSlot |
	domainObject := self basicValueDomainObjectWithString.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'class') equals: 'GtLValueDomainObject'.
	self assert: (jsonData at: 'allInstanceSlots') size equals: 1.
	
	valueSlot := (jsonData at: 'allInstanceSlots') first.
	self assert: (valueSlot at: 'name') equals: #value.
	self assert: (valueSlot at: 'class') equals: 'ByteString'.
	self assert: (valueSlot at: 'value') equals: 'Hello World'.
	
	^ dataBlock
]

{ #category : #examples }
GtLValueDomainObjectExamples >> testObjectDataViewSerialization [
	<gtExample>
	| domainObject compositeView dataBlock jsonData valueSlot |
	domainObject := self basicValueDomainObjectWithTestObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	
	jsonData := dataBlock compositeJsonData.
	self assert: (jsonData at: 'class') equals: 'GtLValueDomainObject'.
	self assert: (jsonData at: 'allInstanceSlots') size equals: 1.
	
	valueSlot := (jsonData at: 'allInstanceSlots') first.
	self assert: (valueSlot at: 'name') equals: #value.
	self assert: (valueSlot at: 'class') equals: 'GtLSerializedObjectValueTestObject'.
	self assert: ((valueSlot at: 'value') includesSubstring: 'TestObject').
	
	^ dataBlock
]

{ #category : #examples }
GtLValueDomainObjectExamples >> testObjectDetailedSerialization [
	<gtExample>
	"Verify the serialization captures the test object's structure properly."
	| domainObject compositeView dataBlock jsonData viewTitles methodSelectors |
	domainObject := self basicValueDomainObjectWithTestObject.
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	
	"Verify views are serialized - GtLValueDomainObject should have some views"
	self assert: (jsonData at: 'views') isNotEmpty.
	viewTitles := (jsonData at: 'views') collect: [ :v | v at: 'title' ].
	self assert: (viewTitles includes: 'Object').
	
	"Verify instance methods are serialized"
	methodSelectors := jsonData at: 'instanceMethods'.
	self assert: (methodSelectors includes: #value).
	self assert: (methodSelectors includes: #value:).
	self assert: (methodSelectors includes: #llmDataViewFor:).
	
	^ dataBlock
]

{ #category : #examples }
GtLValueDomainObjectExamples >> valueWithCollection [
	<gtExample>
	| domainObject compositeView dataBlock jsonData valueSlot |
	domainObject := GtLValueDomainObject new value: #(1 2 3).
	
	self assert: domainObject value equals: #(1 2 3).
	self assert: domainObject isErrorDomainObject not.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	
	self assert: (jsonData at: 'class') equals: 'GtLValueDomainObject'.
	
	valueSlot := (jsonData at: 'allInstanceSlots') first.
	self assert: (valueSlot at: 'name') equals: #value.
	self assert: (valueSlot at: 'class') equals: 'Array'.
	self assert: ((valueSlot at: 'value') includesSubstring: '1').
	
	^ domainObject
]

{ #category : #examples }
GtLValueDomainObjectExamples >> valueWithNil [
	<gtExample>
	| domainObject compositeView dataBlock jsonData valueSlot |
	domainObject := GtLValueDomainObject new value: nil.
	
	self assert: domainObject value isNil.
	self assert: domainObject isErrorDomainObject not.
	
	compositeView := domainObject llmDataViewsFor: GtLDataView new.
	dataBlock := compositeView serializeToLlmPrimiteData.
	jsonData := dataBlock compositeJsonData.
	
	self assert: (jsonData at: 'class') equals: 'GtLValueDomainObject'.
	
	valueSlot := (jsonData at: 'allInstanceSlots') first.
	self assert: (valueSlot at: 'name') equals: #value.
	self assert: (valueSlot at: 'class') equals: 'UndefinedObject'.
	self assert: (valueSlot at: 'value') equals: 'nil'.
	
	^ domainObject
]
