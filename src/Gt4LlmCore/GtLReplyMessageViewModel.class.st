Class {
	#name : #GtLReplyMessageViewModel,
	#superclass : #GtLMessageViewModel,
	#instVars : [
		'executionMessageViewModelsCache',
		'finalMessageViewModel'
	],
	#classVars : [
		'ElementClass'
	],
	#category : 'Gt4LlmCore-UI - View Models'
}

{ #category : #settings }
GtLReplyMessageViewModel class >> elementClass: anElementClass [
	"This is a temporary solution. 
	We will remove it as soon as we finish the new replay message element."

	ElementClass := anElementClass
]

{ #category : #visiting }
GtLReplyMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitReplyMessageViewModel: self
]

{ #category : #'api - converting' }
GtLReplyMessageViewModel >> elementClass [
	^ ElementClass ifNil: [ super elementClass ]
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

{ #category : #initialization }
GtLReplyMessageViewModel >> initialize [
	super initialize.

	executionMessageViewModelsCache := AsyncSharedDictionary new
]

{ #category : #'api - testing' }
GtLReplyMessageViewModel >> isFinished [
	^ self finalMessageViewModel isNotNil
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
	^ BlInsets right: 0 "50"
]
