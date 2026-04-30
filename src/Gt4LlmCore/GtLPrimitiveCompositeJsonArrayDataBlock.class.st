Class {
	#name : #GtLPrimitiveCompositeJsonArrayDataBlock,
	#superclass : #GtLPrimitiveCompositeJsonDataBlock,
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveCompositeJsonArrayDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveCompositeJsonArrayDataBlock: self
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonArrayDataBlock >> condensedJsonBlock [
	^GtLPrimitiveJsonDataBlock new
			dataKey: nil; "is nil as we collect the inner data"
			jsonData: (self jsonDataBlocksCollect:  [ :each | each llmJsonData ])
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonArrayDataBlock >> jsonDataBlocksCollect:  aBlock [
	^self jsonDataBlocks 
			collect: aBlock as: Array
]

{ #category : #accessing }
GtLPrimitiveCompositeJsonArrayDataBlock >> keysForMerge [
	^ {self dataKey}
]
