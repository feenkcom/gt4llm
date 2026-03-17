Class {
	#name : #GtLToolMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLToolMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitToolMessageViewModel: self
]

{ #category : #printing }
GtLToolMessageViewModel >> gtDisplayOn: aStream [
	self message
		ifNil: [ super gtDisplayOn: aStream ]
		ifNotNil: [ :aMessage | 
			aStream nextPutAll: 'View model for '.
			aMessage gtDisplayOn: aStream ]
]
