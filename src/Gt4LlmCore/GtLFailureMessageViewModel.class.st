Class {
	#name : #GtLFailureMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLFailureMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitFailureMessageViewModel: self
]
