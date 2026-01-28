Trait {
	#name : #TGtLMessageViewModelVisitor,
	#category : #'Gt4LlmCore-UI - View Models'
}

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitBasicMessageViewModel: aMessageViewModel [
	
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitErrorMessageViewModel: aMessageViewModel [
	^ self visitMessageViewModel: aMessageViewModel
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitFailureMessageViewModel: aMessageViewModel [
	^ self visitBasicMessageViewModel: aMessageViewModel
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitMessageViewModel: aMessageViewModel [
	^ self visitBasicMessageViewModel: aMessageViewModel
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitNewMessageViewModel: aMessageViewModel [
	^ self visitBasicMessageViewModel: aMessageViewModel
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitReplyMessageViewModel: aMessageViewModel [
	^ self visitMessageViewModel: aMessageViewModel
]

{ #category : #visiting }
TGtLMessageViewModelVisitor >> visitToolMessageViewModel: aMessageViewModel [
	^ self visitMessageViewModel: aMessageViewModel
]
