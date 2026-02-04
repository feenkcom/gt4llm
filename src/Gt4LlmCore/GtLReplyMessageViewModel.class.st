Class {
	#name : #GtLReplyMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLReplyMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitReplyMessageViewModel: self
]

{ #category : #accessing }
GtLReplyMessageViewModel >> messageViewsInto: aStream [
	super messageViewsInto: aStream.

	self hasMessage
		ifTrue: [ aStream
				nextPutAll: (GtPhlowViewsCollector new
						fromObject: self message;
						pragmaNames: self messageViewPragmas;
						collect) ]
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> uiInsets [
	^ BlInsets right: 50
]
