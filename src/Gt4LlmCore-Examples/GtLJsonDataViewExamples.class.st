Class {
	#name : #GtLJsonDataViewExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Data Views'
}

{ #category : #'as yet unclassified' }
GtLJsonDataViewExamples >> standaloneJsonDataViewWithDataKey [
	<gtExample>
	| basicView |
	
	basicView := GtLJsonDataView new
		dataKey: #data;
		data:[ 
			{
				'one' -> 1. 
				'two' -> 2
			} asDictionary].
	
	self assert: basicView title isNil.
	self assert: basicView dataKey equals: #data.
	self 
		assert: basicView llmJsonData
		equals: {
				'one' -> 1.
				'two' -> 2
			} asDictionary.
	
	^basicView
]

{ #category : #'as yet unclassified' }
GtLJsonDataViewExamples >> standaloneJsonDataViewWithDataKey_serialization [
	<gtExample>
	| basicView dataBlock compositeJsonDataBlock concreteJsonDataBlock |
	
	basicView := self standaloneJsonDataViewWithDataKey .
	dataBlock := basicView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: basicView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 0.
	self assert: dataBlock compositeJsonDataBlock notNil.
	
	compositeJsonDataBlock := dataBlock compositeJsonDataBlock.
	self assert: compositeJsonDataBlock sourceDataView isNil.
	self assert: compositeJsonDataBlock dataKey isNil.
	self assert: compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self
		assert: compositeJsonDataBlock llmJsonData
		equals: {'data' -> {
				'one' -> 1.
				'two' -> 2
			} asDictionary} asDictionary.
	
	concreteJsonDataBlock := compositeJsonDataBlock jsonDataBlocks first.
	self assert: concreteJsonDataBlock sourceDataView notNil.
	self assert: concreteJsonDataBlock dataKey equals: #data.
	self
		assert: concreteJsonDataBlock llmJsonData
		equals: {'data' -> {
				'one' -> 1.
				'two' -> 2
			} asDictionary} asDictionary.
	
	^dataBlock
]

{ #category : #'as yet unclassified' }
GtLJsonDataViewExamples >> standaloneJsonDataViewWithoutDataKey [
	<gtExample>
	| basicView |
	
	basicView := GtLJsonDataView new
		data:[ 
			{
				'one' -> 1.
				'two' -> 2
			} asDictionary].
	
	self assert: basicView title isNil.
	self assert: basicView dataKey isNil.
	self 
		assert: basicView llmJsonData
		equals: {
				'one' -> 1.
				'two' -> 2
			} asDictionary.
	
	^basicView
]

{ #category : #'as yet unclassified' }
GtLJsonDataViewExamples >> standaloneJsonDataViewWithoutDataKey_serialization [
	<gtExample>
	| basicView dataBlock compositeJsonDataBlock concreteJsonDataBlock|
	
	basicView := self standaloneJsonDataViewWithoutDataKey .
	dataBlock := basicView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: basicView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 1.
	self assert: dataBlock imageDataBlocks size equals: 0.
	
	compositeJsonDataBlock := dataBlock compositeJsonDataBlock.
	self assert: compositeJsonDataBlock notNil.
	self assert: compositeJsonDataBlock sourceDataView isNil.
	self assert: compositeJsonDataBlock dataKey isNil.
	self assert: compositeJsonDataBlock jsonDataBlocks size equals: 1.
	self
		assert: compositeJsonDataBlock llmJsonData
		equals: {
				'one' -> 1.
				'two' -> 2
			} asDictionary.
	
	concreteJsonDataBlock := compositeJsonDataBlock jsonDataBlocks first.
	self assert: concreteJsonDataBlock sourceDataView notNil.
	self assert: concreteJsonDataBlock dataKey isNil.
	self
		assert: concreteJsonDataBlock llmJsonData
		equals: {
				'one' -> 1.
				'two' -> 2
			} asDictionary.
	
	^dataBlock
]
