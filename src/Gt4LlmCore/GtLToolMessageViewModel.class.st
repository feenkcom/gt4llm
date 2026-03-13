Class {
	#name : #GtLToolMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLToolMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitToolMessageViewModel: self
]
