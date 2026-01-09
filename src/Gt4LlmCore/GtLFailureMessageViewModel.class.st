Class {
	#name : #GtLFailureMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#traits : 'TGtLWithMessage',
	#classTraits : 'TGtLWithMessage classTrait',
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLFailureMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitFailureMessageViewModel: self
]
