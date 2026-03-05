Extension { #name : #Object }

{ #category : #'*Gt4LlmCore' }
Object >> addContentOneLineSummaryTo: aWriteStream [
	self gtDisplayOn: aWriteStream
]

{ #category : #'*Gt4LlmCore' }
Object >> contentOneLineMultiLabelSummaryWith: aBuilder [
	aBuilder newTextFromStringStream: [ :aWriteStream | 
		self addContentOneLineSummaryTo: aWriteStream ]
]

{ #category : #'*Gt4LlmCore' }
Object >> gtActionObjectChatFor: anAction [
	<gtAction>
	| chatBlock |
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].

	chatBlock := [ GtLChat new
			markdownResponse;
			sendWith: [ :m | 
				m
					addPlainInputObject: self named: 'Object';
					markdown: 'Describe the object' ] ].

	^ anAction button
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about this object';
		target: GtPhlowObjectContextMenuTarget;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		menuItemPreview: [ self gtDisplayText ];
		action: [ :button | 
			button phlow spawnObject: chatBlock value ];
		primaryModifierAction: [ :aButton | 
				BlSpace new
					withCommonSettings;
					objectInPager: chatBlock value;
					showFrom: aButton ]
			mouseCursor: BlCopyCursor new
]
