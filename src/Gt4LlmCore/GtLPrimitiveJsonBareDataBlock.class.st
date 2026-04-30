Class {
	#name : #GtLPrimitiveJsonBareDataBlock,
	#superclass : #GtLPrimitiveStandaloneJsonBlock,
	#category : 'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveJsonBareDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveJsonBareDataBlock: self
]
