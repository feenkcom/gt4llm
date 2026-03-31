"
Examples for GtLClassRemovalResult domain object.
"
Class {
	#name : #GtLClassRemovalResultExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLClassRemovalResultExamples >> classRemovalResultCreation [
	<gtExample>
	| result |
	result := GtLClassRemovalResult new
		removedClassName: 'MyTestClass';
		status: 'removed';
		yourself.
	self assert: result removedClassName equals: 'MyTestClass'.
	self assert: result status equals: 'removed'.
	^ result
]

{ #category : #examples }
GtLClassRemovalResultExamples >> classRemovalResultDataViewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| result compositeView dataBlock jsonData expectedJson |
	result := self classRemovalResultCreation.
	compositeView := result llmDataViewsFor: GtLDataView new.
	self assert: compositeView dataViews size equals: 1.
	
	dataBlock := compositeView serializeToLlmPrimiteData.
	self assert: dataBlock isNotNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks isEmpty.
	
	jsonData := dataBlock compositeJsonData.
	expectedJson := {
		#removedClassName -> 'MyTestClass'.
		#status -> 'removed'
	} asDictionary.
	self assert: jsonData equals: expectedJson.
	
	^ dataBlock
]
