Class {
	#name : #GtLReplyMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLReplyMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitReplyMessageViewModel: self
]
