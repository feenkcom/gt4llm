Class {
	#name : #GtLPrimitiveJsonArrayDataBlock,
	#superclass : #GtLPrimitiveStandaloneJsonBlock,
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveJsonArrayDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveJsonArrayDataBlock: self
]
