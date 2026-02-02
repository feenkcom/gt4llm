Class {
	#name : #GtLNewMessageViewModel,
	#superclass : #GtLBasicMessageViewModel,
	#instVars : [
		'connectionRegistry',
		'chat',
		'files',
		'contents'
	],
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
GtLNewMessageViewModel >> acceptVisitor: aVisitor [
	^ aVisitor visitNewMessageViewModel: self
]

{ #category : #'api - message' }
GtLNewMessageViewModel >> attachFile: aFileReference [
	files add: aFileReference
]

{ #category : #accessing }
GtLNewMessageViewModel >> chat [
	<return: #GtLChat>
	^ chat
]

{ #category : #'api - initialization' }
GtLNewMessageViewModel >> chat: aChat [
	chat := aChat
]

{ #category : #accessing }
GtLNewMessageViewModel >> connectionRegistry [
	^ connectionRegistry
		ifNil: [ connectionRegistry := GtLConnectionRegistry uniqueInstance ]
]

{ #category : #accessing }
GtLNewMessageViewModel >> connectionRegistry: anObject [
	connectionRegistry := anObject
]

{ #category : #'as yet unclassified' }
GtLNewMessageViewModel >> connectionString [
	^ (self connectionRegistry connectionFor: self provider)
		ifNil: [ self provider modelName ]
		ifNotNil: #connectionString
]

{ #category : #'api - message' }
GtLNewMessageViewModel >> contents [
	^ contents
]

{ #category : #'api - accessing' }
GtLNewMessageViewModel >> contents: aString source: aSource [
	"Set user message text that is going to be sent."

	contents := aString.
	self onContentsChangedSource: aSource
]

{ #category : #'api - converting' }
GtLNewMessageViewModel >> elementClass [
	^ GtLNewMessageElement
]

{ #category : #'api - accessing' }
GtLNewMessageViewModel >> files [
	^ files
]

{ #category : #'api - accessing' }
GtLNewMessageViewModel >> id [
	"Return a unique id that identifies this message"

	^ '87fe83dd-90cd-0d00-9ada-2ba30d0bb652'
]

{ #category : #initialization }
GtLNewMessageViewModel >> initialize [
	super initialize.
	contents := ''.
	files := OrderedCollection new.
]

{ #category : #'private - event handling' }
GtLNewMessageViewModel >> onContentsChangedSource: aSource [ 
	self announcer
		announce: (GtLMessageViewModelContentsChanged new
				messageViewModel: self;
				source: aSource)
]

{ #category : #'api - chat' }
GtLNewMessageViewModel >> provider [
	^ self chat provider
]

{ #category : #'api - chat' }
GtLNewMessageViewModel >> provider: aProvider [
	self chat provider: aProvider
]

{ #category : #actions }
GtLNewMessageViewModel >> sendMessage [
	<return: #TAsyncPromise>
	| aMessageContent aMessageFiles |
	contents ifNil: [ ^ nil asAsyncPromise ].
	contents ifEmpty: [ ^ nil asAsyncPromise ].

	aMessageContent := self contents.
	aMessageFiles := self files asArray.

	self contents: '' source: self.
	files := OrderedCollection new.

	^ aMessageFiles
		ifEmpty: [ chat sendMarkdown: aMessageContent ]
		ifNotEmpty: [ chat sendFiles: aMessageFiles withMessage: aMessageContent ]
]
