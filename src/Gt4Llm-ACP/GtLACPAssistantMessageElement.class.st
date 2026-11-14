"
I coordinate the header, work and final-reply elements of an assistant response. GtLACPAssistantWorkElement owns work composition, summary and delegated-agent refresh. GtLACPAssistantFinalMessageElement owns final-reply presentation. I retain cached comment elements shared across the two sections, preserving their editors when a comment becomes the final reply.
"
Class {
	#name : #GtLACPAssistantMessageElement,
	#superclass : #GtLACPChatMessageElement,
	#instVars : [
		'commentElements',
		'structuralSnapshot',
		'renderedVersion',
		'finalMessageElement',
		'workElement'
	],
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #updating }
GtLACPAssistantMessageElement >> build [
	super build.
	structuralSnapshot := self presentationStructure.
	renderedVersion := viewModel renderingVersion
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildContent [
	self buildWorkSection.
	self buildFinalReplySection.
	self buildErrorContent
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildErrorContent [
	viewModel turn error
		ifNotNil: [ :error | self addChild: (self textElementFor: error printString) ]
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildFinalReplySection [
	viewModel replyMessages ifEmpty: [ ^ self ].
	finalMessageElement := GtLACPAssistantFinalMessageElement new
			commentElement: (self commentElementFor: viewModel replyMessages first);
			messageViewModel: viewModel;
			yourself.
	self addChild: finalMessageElement
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildHeader [
	| header |
	header := super buildHeader.
	header margin: (BlInsets bottom: 2).
	viewModel turn isActive
		ifTrue: [ header
				addChild: (self workIndicatorFor: viewModel turn id: #'acp-work-indicator')
				at: 2 ].
	header
		addChild: (GtLACPInputNeededElement new
				id: viewModel inputNeededId;
				forTurn: viewModel turn;
				yourself)
		at: 2.
	^ header
]

{ #category : #building }
GtLACPAssistantMessageElement >> buildWorkSection [
	viewModel message hasWork ifFalse: [ ^ self ].
	workElement
		ifNil: [ workElement := GtLACPAssistantWorkElement new
					commentElementProvider: [ :message | self commentElementFor: message ];
					messageViewModel: viewModel;
					yourself ]
		ifNotNil: [ workElement rebuild ].
	self addChild: workElement
]

{ #category : #building }
GtLACPAssistantMessageElement >> commentElementFor: aMessage [
	| element |
	element := self commentElements
			at: aMessage
			ifAbsentPut: [ GtLACPAssistantCommentElement new
					phlowContext: viewModel phlowContext;
					message: aMessage;
					yourself ].
	element refresh.
	^ element
]

{ #category : #accessing }
GtLACPAssistantMessageElement >> commentElements [
	^ commentElements ifNil: [ commentElements := IdentityDictionary new ]
]

{ #category : #initialization }
GtLACPAssistantMessageElement >> initialize [
	super initialize.
	self layout cellSpacing: 0.
]

{ #category : #building }
GtLACPAssistantMessageElement >> presentationStructure [
	| turn |
	turn := viewModel turn.
	^ {turn stateName.
		viewModel message localActivityItems asArray.
		viewModel replyMessages asArray.
		viewModel message delegatedMessages asArray.
		(viewModel toolCalls
			collect: [ :tool | 
				{tool summary.
					(tool permissionRequests
						collect: [ :request | 
							{request.
								request state} ]) asArray.
					(tool elicitationRequests
						collect: [ :request | 
							{request.
								request state} ]) asArray} ]) asArray.
		(turn permissionRequests
			collect: [ :request | 
				{request.
					request state} ]) asArray.
		(turn elicitationRequests
			collect: [ :request | 
				{request.
					request state} ]) asArray.
		turn error}
]

{ #category : #updating }
GtLACPAssistantMessageElement >> refresh [
	| snapshot version |
	version := viewModel renderingVersion.
	renderedVersion = version ifTrue: [ ^ self ].
	self commentElements valuesDo: [ :element | element refresh ].
	snapshot := self presentationStructure.
	snapshot = structuralSnapshot
		ifFalse: [ self removeChildren.
			finalMessageElement := nil.
			self addChild: self buildHeader as: #'acp-message-header'.
			self buildContent.
			structuralSnapshot := snapshot ].
	self updateExpansion.
	renderedVersion := version
]

{ #category : #updating }
GtLACPAssistantMessageElement >> updateExpansion [
	workElement ifNotNil: [ workElement refresh ].
	finalMessageElement ifNotNil: [ finalMessageElement refresh ]
]

{ #category : #accessing }
GtLACPAssistantMessageElement >> workElement [
	^ workElement
]

{ #category : #building }
GtLACPAssistantMessageElement >> workIndicatorFor: aTurn id: anId [
	^ BrLabel new
		id: anId;
		aptitude: (BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		text: (aTurn isCancelling ifTrue: [ 'Stopping…' ] ifFalse: [ 'Working…' ]);
		margin: (BlInsets left: 8);
		constraintsDo: [ :c | c linear vertical alignCenter ];
		yourself
]
