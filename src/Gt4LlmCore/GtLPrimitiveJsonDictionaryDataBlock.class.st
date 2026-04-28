Class {
	#name : #GtLPrimitiveJsonDictionaryDataBlock,
	#superclass : #GtLPrimitiveJsonDataBlock,
	#category : #'Gt4LlmCore-Data Views'
}

{ #category : #visiting }
GtLPrimitiveJsonDictionaryDataBlock >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLPrimitiveJsonDictionaryDataBlock: self
]
