Class {
	#name : #GtLReplyMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#instVars : [
		'executionMessageViewModelsCache',
		'finalMessageViewModel',
		'isToolsExpanded',
		'toolsContentsHeight'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLReplyMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitReplyMessageViewModel: self
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> executionMessageViewModelsStream [
	^ self message executionMessagesStream
		map: [ :aMessage | aMessage asViewModel ]
		cache: executionMessageViewModelsCache
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> finalMessageViewModel [
	^ finalMessageViewModel
		ifNil: [ finalMessageViewModel := self message finalMessage ifNotNil: #asViewModel ]
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> finishedAt [
	^ self message finishedAt
]

{ #category : #initialization }
GtLReplyMessageViewModel >> initialize [
	super initialize.

	executionMessageViewModelsCache := AsyncSharedDictionary new.
	isToolsExpanded := false.
	toolsContentsHeight := nil.
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> isContentsExpanded [
	^ self isExpanded
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> isContentsExpanded: aBoolean source: aSource [
	self isExpanded: aBoolean
]

{ #category : #'api - testing' }
GtLReplyMessageViewModel >> isFinished [
	^ self finalMessageViewModel isNotNil
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> isToolsExpanded [
	^ isToolsExpanded
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> isToolsExpanded: aBoolean source: aSource [
	isToolsExpanded := aBoolean
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
GtLReplyMessageViewModel >> toolsContentsHeight [
	<return: #Number or: nil>
	^ toolsContentsHeight
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> toolsContentsHeight: aHeightOrNil [
	toolsContentsHeight := aHeightOrNil
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> uiInsets [
	^ BlInsets right: 0 "50"
]

{ #category : #'api - accessing' }
GtLReplyMessageViewModel >> userMessageCreatedAt [
	^ self message userMessageCreatedAt
]
