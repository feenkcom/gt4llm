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
	chatBlock := [ | c |
		c := GtL gt.
		c objectStorage addNewObject: self.
		c ].
	^ anAction button
		icon: BrGlamorousVectorIcons chat;
		tooltip: 'Chat about this object';
		target: GtPhlowObjectContextMenuTarget;
		menuItemGroup: BrMenuItemGroupConfiguration default;
		menuItemPreview: [ self gtDisplayText ];
		action: [ :button | button phlow spawnObject: chatBlock value ];
		primaryModifierAction: [ :aButton | 
				BlSpace new
					withCommonSettings;
					objectInPager: chatBlock value;
					showFrom: aButton ]
			mouseCursor: BlCopyCursor new
]
