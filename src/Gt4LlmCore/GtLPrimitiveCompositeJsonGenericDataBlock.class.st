Class {
	#name : #GtLPrimitiveCompositeJsonGenericDataBlock,
	#superclass : #GtLPrimitiveCompositeJsonDataBlock,
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveCompositeJsonGenericDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveCompositeJsonGenericDataBlock: self
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonGenericDataBlock >> condensedJsonBlock [
	(jsonDataBlocks size = 1 and: [
		jsonDataBlocks anyOne class = GtLPrimitiveJsonBareDataBlock ])
			ifTrue: [ 	
				^jsonDataBlocks anyOne class new
					jsonData:	jsonDataBlocks anyOne jsonData ].

	^jsonDataBlocks 
		inject: (GtLPrimitiveJsonDataBlock new
			dataKey: nil; "is nil as we collect the inner data, and it could have same key"
			jsonData: Dictionary new) 
		into: [ :resultBlock :currentBlock |
			resultBlock 
				addJsonBlock: currentBlock 
				disabiguatingKeys: #('dataViewError').
			resultBlock	]
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonGenericDataBlock >> keysForMerge [
	^self dataKey
		ifNil: [ self condensedJsonBlock jsonData keys ] 
		ifNotNil: [ {self dataKey} ]
]
