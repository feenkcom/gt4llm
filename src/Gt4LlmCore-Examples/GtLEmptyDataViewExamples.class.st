"
I provide examples for GtLEmptyDataView.
"
Class {
	#name : #GtLEmptyDataViewExamples,
	#superclass : #GtLDataViewExamples,
	#category : 'Gt4LlmCore-Examples-Data Views'
}

{ #category : #examples }
GtLEmptyDataViewExamples >> basicEmptyDataView [
	<gtExample>
	| dataView |
	
	dataView := GtLEmptyDataView new.
	
	self assert: dataView title isNil.
	self assert: dataView dataKey isNil.
	
	^ dataView
]

{ #category : #examples }
GtLEmptyDataViewExamples >> emptyDataView_serialization [
	<gtExample>
	| dataView dataBlock |
	
	dataView := self basicEmptyDataView.
	dataBlock := dataView serializeToLlmPrimiteData.
	
	self assert: dataBlock sourceDataView equals: dataView.
	self assert: dataBlock dataKey isNil.
	self assert: dataBlock dataBlocks size equals: 0.
	self assert: dataBlock imageDataBlocks size equals: 0.
	self assert: dataBlock containedJsonDataBlocksCount equals: 0.
	
	^ dataBlock
]
