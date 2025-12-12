Extension { #name : #GtLlmChatMessage }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> asViewModel [
	^ GtLlmThreadMessageViewModel new threadMessage: self
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new
				threadMessageViewModel: self asViewModel ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtJsonFor: aView [
	<gtView>
	<gtLlmMessageView>
	[ self contentJson ] on: Error do: [ ^ aView empty ].

	^ (self contentJson gtTreeFor: aView)
		title: 'JSON data';
		priority: 10
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtMessageFilesFor: aView [
	<gtView>
	<gtLlmMessageView>
	| messageFiles |
	messageFiles := self messageFiles.

	messageFiles ifEmpty: [ ^ aView empty ].

	^ aView columnedList
		title: 'Files';
		items: [ messageFiles ];
		column: 'Extent' text: #extent;
		column: 'Size' text: [ :aFile | aFile imageInfo byteSize  ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> gtPharoRewriteFor: aView [
	<gtView>
	<gtLlmMessageView>
	| snippet rewrite |
	self isAssistantRole ifFalse: [ ^ aView empty ].
	rewrite := STONJSON
			fromString: (self contentJson at: 'Pharo Rewrite' ifAbsent: [ ^ aView empty ]).

	snippet := LePharoRewriteSnippet new
			search: (rewrite at: 'search' ifAbsent: [ '' ]);
			replace: (rewrite at: 'replace' ifAbsent: [ '' ]);
			yourself.

	^ aView forward
		title: 'Rewrite';
		priority: 5;
		object: [ snippet ];
		view: #gtLiveFor:
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> messageFiles [
	self images
		ifNotNil: [ ^ self images
				collect: [ :aBase64Image | 
					| aByteArray |
					aByteArray := aBase64Image base64Decoded.
					SkiaImage
						fromBuffer: aByteArray
						start: 0
						end: aByteArray size - 1 ] ].

	self contentFiles
		ifNotEmpty: [ :contentFiles | 
			^ contentFiles
				collect: [ :aBase64Image | 
					| aByteArray |
					aByteArray := aBase64Image base64Decoded.
					SkiaImage
						fromBuffer: aByteArray
						start: 0
						end: aByteArray size - 1 ] ].

	^ {}
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmChatMessage >> uuidClass [
	"This is in a separate method in an extension package to be able to compile the base class to Gemstone"
	^ UUID
]
