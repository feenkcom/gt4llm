Class {
	#name : #GtLErrorMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLErrorMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitErrorMessageViewModel: self
]
