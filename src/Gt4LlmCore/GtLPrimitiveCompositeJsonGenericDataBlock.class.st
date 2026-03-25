Class {
	#name : #GtLPrimitiveCompositeJsonGenericDataBlock,
	#superclass : #GtLPrimitiveCompositeJsonDataBlock,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLPrimitiveCompositeJsonGenericDataBlock >> condensedJsonBlock [
	^jsonDataBlocks 
		inject: (GtLPrimitiveJsonDataBlock new
			dataKey: self dataKey;
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
